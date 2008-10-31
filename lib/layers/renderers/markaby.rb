module Waves
  
  module Renderers

    module Markaby
      
      Extension = :mab
      
      extend Waves::Renderers::Mixin
      
      def self.included( app )
        require 'markaby'
        ::Markaby::Builder.set( :indent, 2 )
        
        super

        Waves::ResponseMixin.module_eval do
          def mab(string, assigns)
            builder = ::Markaby::Builder.new( assigns )
            #helper = helper( path )
            #builder.meta_eval { include( helper ) }
            builder.instance_eval( string )
            builder.to_s
          end
        end

      end
      
      def self.render( path, assigns )
        builder = ::Markaby::Builder.new( assigns )
        helper = helper( path )
        builder.meta_eval { include( helper ) }
        builder.instance_eval( template( path ) )
        builder.to_s
      end

    end
  
  end

end