require 'foundations/compact'
require 'layers/renderers/markaby'

require 'syntaxi'
require 'sequel'

module Spit
  include Waves::Foundations::Compact
  include Waves::Renderers::Markaby
  
  # Syntaxi stuff
  Syntaxi::line_number_method = 'floating'
  Syntaxi::wrap_at_column = 70
  
  # @views is filled with markaby below
  @views = {}
  def self.views ; @views ; end

  def self.database ; @db ||= Sequel.connect('sqlite://spit.db') ; end
  
  # Sequel#create_table will not clobber, so this ensures the table exists.
  Spit.database.create_table :spits do
    column :name, :integer
    column :body, :text
  end unless Spit.database.table_exists? :spits
 
  module Resources
    class Map
      spits = Spit.database[:spits]
 
       on(:get, [ :spit_id ]) do
         spit = spits.filter( :name => captured.spit_id )
         mab( Spit.views[:show], { :name => spit['name'], :body => spit['body'] } )
       end
 
       on(:put, [ :spit_id ]) do
         spit = spits.filter( :name => captured.spit_id )
         mab( Spit.views[:edit], { :name => spit['name'], :body => spit['body'] } )
       end
       
       on(:get, [ ]) { mab( Spit.views[:edit], { :name => spits.count + 1 } ) }
       on(:post, [ ]) { spits << { :name => (spits.count + 1), :body => params['spit_body'] } }
 
       on(:post, [ :spit_id ]) { spits.filter( :name => captured.spit_id ).update( :body => params['spit_body'] ) }
       on(:delete, [ :spit_id ]) { spits.filter( :name => captured.spit_id ).delete }
 
    end
  end
 
 
# VIEWS
  def syntaxify(text)
    html = Syntaxi.new("[code lang='ruby']#{text}[/code]").process
    #"<div class=\"syntax syntax_ruby\">#{html}</div>"
  end
 
  @views[:show] = <<SHOW
html do
  head do
    title "spit: #{@name}"
  end
  body do
    div.spit do
      self << @body
    end
  end
end
SHOW
 
  @views[:edit] = <<EDIT
html do
  head do
    title "spit: #{@name} {EDIT}"
  end
  body do
    form :action => "/", :method => "POST" do
      textarea :name => "spit_body", :id => "spit_body" do
        self << @body unless @body.nil?
      end
      input :type => "submit", :value => "spit"
    end
  end
end
EDIT

end