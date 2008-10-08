module Waves
  module Layers
    module Caches

      module File
        
        def self.included(app)
          require 'layers/caches/file/engine'

          if Waves.cache.nil?
            Waves.cache = Waves::Caches::File.new( Waves.config.cache )
          end
          
        end
      end

    end
  end
end

