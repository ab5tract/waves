module Waves
  module Cache

    class Memcached < Waves::Cache::IPI
      require 'memcached'

      def initialize(args)
          # initialize takes what you would throw at Memcached.new

          args[:servers] = args[:server] unless args[:server].nil?
          raise ArgumentError, "need :servers to not be nil" if args[:servers].nil?
          args[:opt] = args.has_key?(:opt) ? args[:opt] : {}
          @cache = ::Memcached.new(args[:servers], args[:opt])

      end

      def store(key,value, ttl = 0, marshal = true)

          cache = @cache.clone
          cache.add(key.to_s,value,ttl,marshal)
          cache.destroy

      end

      def fetch(key)
#        Waves.synchronize do
          
          cache = @cache.clone
          cache.get(key.to_s)
          cache.destroy

#        end
      rescue ::Memcached::NotFound => e
        # In order to keep the Memcached layer compliant with Waves::Cache...
        # ...we need to be able to expect that an absent key raises KeyMissing
        raise KeyMissing, "#{key} doesn't exist!\n\t\t memcached says: #{e}"
      end

      def delete(*keys)
#        Waves.synchronize do

          cache = @cache.clone
          keys.each {|key| cache.delete(key.to_s) }
          cache.destroy

#        end
      end

      def clear
#        Waves.synchronize do

          cache = @cache.clone
          cache.flush
          cache.destroy

#        end
      end

      alias_method :add, :store   # Override our natural Waves::Cache :store method with Memcache's :add
      alias_method :get, :fetch   # Override our natural Waves::Cache :fetch method with Memcache's :get

      def method_missing(*args, &block)
#        Waves.synchronize do

          cache = @cache.clone
          cache.__send__(*args, &block)
          cache.destroy

#        end
      rescue => e
        Waves.log.error e.to_s
        nil
      end

    end
  end
end