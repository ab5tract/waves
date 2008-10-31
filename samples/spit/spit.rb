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
 
  attr_reader :views
  @views = {}

  @database = Sequel.connect 'sqlite://spit.db'
 
  module Resources
    class Map
      spits = @database[:spits]
 
       on(:get, [ id ]) do
         spit = spits.filter( :name => id )
         mab( Spit.views[:show], { :name => spit.name, :body => spit.body } )
       end
 
       on(:put, [ id ]) do
         spit = spits.filter( :name => id )
         mab( Spit.views[:edit], { :name => spit.name, :body => spit.body } )
       end
       
       on(:get, [ ]) { mab( Spit.views[:edit], { :name => spits.count + 1 } ) }
       on(:post, [ ]) { spits << { :name => (spits.count + 1), :body => spit_body } }
 
       on(:post, [ id ]) { spits.filter( :name => id ).update( :body => spit_body ) }
       on(:delete, [ id ]) { spits.filter( :name => id ).delete }
 
    end
  end
 
 
# VIEWS
  def syntaxify(text)
    html = Syntaxi.new("[code lang='ruby']#{text}[/code]").process
    "<div class=\"syntax syntax_ruby\">#{html}</div>"
  end
 
  @views[:show] = <<SHOW
head do
  title "spit: #{@name}"
end
body do
  div.spit do
    syntaxify @body
  end
end
SHOW
 
  @views[:edit] = <<EDIT
head do
  title "spit: #{@name} {EDIT}"
end
body do
  form :action => "/", :method => "POST" do
  textarea :name => "spit_body", :id => "spit_body" { @body unless @body.nil? }
  input :type => "submit", :value => "spit"
end
EDIT

end