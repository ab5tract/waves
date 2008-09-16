module Waves

  module Cache
<<<<<<< HEAD:lib/cache/cache.rb
    class API

    # Exception classes
    class KeyMissing < StandardError; end
      
<<<<<<< HEAD:lib/cache/cache.rb
    # Class method to keep track of layers
    @layers = {}
    def self.layers(layer = nil, namespace = nil)
      unless layer.nil?
        @layers[layer] = namespace
      else
        @layers
      end
    end
    
=======
>>>>>>> 1847895... the strangeness must be understand... Waves::Cache -> Waves::Cache::API, Waves::Layers::Cache::File -> Waves::Cache::File, etc... but what happened to synchronize?:lib/cache/cache.rb
    # Universal to all cache objects.
    def [](key)
      fetch(key)
    end
=======
    class IPI
>>>>>>> 1833f51... Prettier than ever.:lib/cache/cache-ipi.rb

      # Exception classes
      class KeyMissing < StandardError; end

      # Universal to all cache objects.
      def [](key)
        fetch(key)
      end

      def []=(key,value)
        store(key,value)
      end

      def exists?(key)
        fetch(key)
      rescue KeyMissing
        return false
      else
        return true
      end

      alias_method :exist?, :exists?

      # Replicate the same capabilities in any descendent of Waves::Cache for API compatibility.

      def initialize
        @cache = {}
      end


      def store(key, value, ttl = {})
        Waves.synchronize do
        @cache[key] = {
          :expires => ttl.kind_of?(Numeric) ? Time.now + ttl : nil,
          :value => value
        }
        end
      end

      def delete(*keys)
       Waves.synchronize { keys.each {|key| @cache.delete(key) }}
      end

      def clear
        Waves.synchronize { @cache.clear }
      end

      def fetch(key)
        Waves.synchronize do

          raise KeyMissing, "#{key} doesn't exist in cache" if @cache.has_key?(key) == false
          return @cache[key][:value] if @cache[key][:expires].nil?

          if @cache[key][:expires] > Time.now
            @cache[key][:value]
          else
            delete key
            raise KeyMissing, "#{key} expired before access attempt"
          end

        end
      end

    end
  end

end
