# bin/waves wants to handle itself in all possible scenarios.
# waves |generate| [options]

module Bin
  module Waves 
    module Generate 
      require 'rubygems'
      require 'rakegen'
      
      require File.join(WAVES, 'lib', 'ext', 'string')
    
      def generate( options )
        #app_path = options
        puts options.to_s
        app_name = File.basename(app_path)
        if app_name =~ /[^\w\d_]/
          raise ArgumentError, <<-TEXT
        Unusable name: \"#{app_name}\"
        Application names may contain only letters, numbers, and underscores."
        TEXT
        end
 
        available_orms = [ 'sequel' , 'active_record' , 'none' ]
        orm = options.find {|x| x =~ /--orm/; x.snake_case }
        orm_require, orm_include = case orm
        when 'sequel'
          ["require 'layers/orm/sequel'", "include Waves::Layers::ORM::Sequel"]
        when /active([-_]*)record/
          ["require 'layers/orm/active_record'", "include Waves::Layers::ORM::ActiveRecord"]
        when 'none'
          ['', '# This app was generated without an ORM layer.']
        else
          puts "I'm sorry, '#{orm}' is not listed as an available option.\nTry: \t"
          available_orms.each { |x| puts "\t\t#{x}" }
          raise ArgumentError
        end
 
        # 'Compact' does not use a rake test. Should this be available as an command switch?
        skip_rake = false

        case Choice.choices.template
        when 'classic'
          template = "#{WAVES}/app/classic"
        when 'compact'
          compact_app = <<-COMPACT
        require 'foundations/compact'
 
        module #{app_name}
          include Waves::Foundations::Compact
 
          module Resources
            class Map
            end

          end
        end
        COMPACT
          skip_rake = true
          File.open(app_path / app_name + '.rb', 'w') {|file| file.print compact_app}
        else
          puts "I'm sorry, '#{Choice.choices.template}' is not an available option."
          raise ArgumentError
        end
 
        unless skip_rake
          generator = Rakegen.new("waves:app") do |gen|
            gen.source = template
            gen.target = app_path
            gen.template_assigns = {:name => app_name.camel_case, :orm_require => orm_require, :orm_include => orm_include }
          end
        end
 
        puts "** Creating new Waves application ..."
 
        Rake::Task["waves:app"].invoke unless skip_rake
 
        puts "** Application created!"
      end
    end
  end
end