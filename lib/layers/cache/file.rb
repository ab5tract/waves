module Waves
  module Layers
    module Cache

      module File
        
        def self.included(app)
          require 'layers/cache/file/file-ipi'

          if Waves.cache.nil?
            Waves.cache = Waves::Cache::File.new( Waves.config.cache )
            Waves.log.info "Using Waves::Cache::File for Waves.cache with directory #{Waves.config.cache[:dir]}"
          end
          
        end
      end

    end
  end
end

