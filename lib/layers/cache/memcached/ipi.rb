module Waves
  module Layers
    module Cache

      module Memcached
        class IPI < Waves::Cache
          require 'memcached'
          
          def initialize(args)
            # initialize takes what you would throw at Memcached.new, but in the form of a hash,
            # so a direct call looks like:
            #    Waves::Layers::Cache::Memcached.new { :servers => ['this:10909','that:14405'], :opt => {:prefix_key => 'test'} }
            # Mainly we expect you will be specifying these things in your configurations files using the 'cache' attribute.

            raise ArgumentError, "need :servers to not be nil" if args[:servers].nil?
            args[:opt] = args.has_key?(:opt) ? args[:opt] : {}
            @cache = ::Memcached.new(args[:servers], args[:opt])
          end

          def add(key,value, ttl = 0, marshal = true)
            @cache.add(key.to_s,value,ttl,marshal)
          end

          def get(key)
            @cache.get(key.to_s)
          rescue ::Memcached::NotFound => e
            # In order to keep the Memcached layer compliant with Waves::Cache...
            # ...we need to be able to expect that an absent key raises KeyMissing
            raise KeyMissing, "#{key} doesn't exist, #{e}"
          end

          def delete(*keys)
            keys.each {|key| @cache.delete(key.to_s) }
          end

          def clear
            @cache.flush
          end

          alias_method :store, :add   # Override our natural Waves::Cache :store method with Memcache's :add
          alias_method :fetch, :get   # Override our natural Waves::Cache :fetch method with Memcache's :get

          def method_missing(*args, &block)
            @cached.__send__(*args, &block)
          rescue => e
            Waves::Logger.error e.to_s
            nil
          end
        end

      end
    end
  end
end