# Waves::Caches::Hash - not an abstract class, an ab5tract class

module Waves

  module Caches
    
    class Hash

      def initialize
        @cache = {}  
      end

      # Universal to all cache objects.
      def [](key)
        fetch(key)
      end

      def []=(key,value)  #:TODO:add optional hash argument *params
        store(key,value )
      end

      def exists?(key)
        fetch(key) == nil ? true : false
      end

      alias :exist? :exists?

      # Replicate the same capabilities in any mixin for Waves::Caches on grounds of API compatibility.

      def store(key, value, ttl = nil)
        item = { :value => value }
        item[ :expires ] = Time.now + ttl if ttl
        Waves.synchronize { @cache[key] = item }
      rescue TypeError => e
        raise e, "The ttl value was a wrong type"
      end

      def delete(*keys)
       Waves.synchronize { keys.each { |key| return nil unless (@cache.has_key?(key) and @cache.delete(key)) }}
      end

      def clear
        Waves.synchronize { @cache.clear }
      end

      def fetch(*keys)    # :TODO: Should probably take a splat
        Waves.synchronize do
          f = Proc.new do |key|
            return nil unless item = @cache[ key ]
            if item[:expires] and item[:expires] < Time.now
              @cache.delete( key )
            end
            item[:value]
          end
          keys.respond_to?(:last) ? f.call(keys) : keys.each{|key| f.call(key) }
        end
      end

    end
  end
end
