module Waves
  module Layers
    module MVC

      def self.included( app )
        
        def app.models ; self::Models ; end
        def app.views ; self::Views ; end
        def app.controllers ; self::Controllers ; end
        def app.helpers ; self::Helpers ; end
        

        app.instance_eval do
          # include AutoCode

          auto_create_module( :Models ) do
            include AutoCode
            auto_create_class
            auto_load true, :directories => [ :models ]
          end

          auto_create_module( :Views ) do
            include AutoCode
            
            # rendering logic: mixin?
            auto_create_class true, Waves::Views::Base
            auto_load true, :directories => [ :views ]
          end

          auto_create_module( :Controllers ) do
            include AutoCode
            
            # this ought to be a mixin
            const_set( :Default, Class.new( Waves::Controllers::Base ) ).module_eval do

              def all; model.all; end

              def find( name ); model[ :name => name ] or not_found; end

              def create; model.create( attributes ); end

              def update( name )
                instance = find( name )
                instance.set( attributes )
                instance.save_changes
              end

              def delete( name ); find( name ).destroy; end

            end

            auto_create_class true, self::Default
            auto_load true, :directories => [ :controllers ]
            
          end

          auto_create_module( :Helpers ) do
            include AutoCode
            auto_create_module
            auto_load true, :directories => [ :helpers ]
            auto_eval( true ){ include Waves::Helpers::Default }
          end          

          auto_eval :Resources do
            const_set( :Default, Class.new( Waves::Resources::Base ) ).module_eval do
              def __c ; @controller ||= controllers[ resource ].process( @request ) { self } ; end
              def __v ; @view ||= views[ resource ].process( @request ) { self } ; end
              def action( method, *args ) ; @data = __c.send( method, *args ) ; end
              def render( method ) ; puts "RENDER: #{resource}"; __v.send( method, ( @data.kind_of?( Enumerable ) ? resources : resource ) => @data ) ; end
              def method_missing( name, *args, &block) ; params[ name ] ; end
            end
            auto_create_class true, self::Default
          end
          
        end
      end
    end
  end
end
