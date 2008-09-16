##* layers/cache/file/file-ipi.rb
##* IPI - Stands for Implemented [Application] Programming Interface
###* "Just doing what it does, cousin."
#*
#* For all those looking for a cache to get it done with no fuss. Because its an iPi, you can code to it confidently,
#* knowing that you can switch out the backend in a seamless fashion.


module Waves
  module Cache

    class File < Waves::Cache::IPI

      #* initialize
      #* - commonly attached to Waves.cache with the value of the Waves.config.cache configuration attribute hash
      #* - which is :dir => 'app-local/tmp' until casually overridden in configurations
      #*   your core app's configuration files (see Waves::Configurations::Default for more information about
      #*   our )
      def initialize(config)
        raise ArgumentError, ":dir needs to not be nil" if config[:dir].nil?
        @directory = config[:dir]
        @cache = {}
      end

      ##* store(key, value, ttl = {}) *##
      def store(key, value, ttl = {})
        Waves.synchronize do

          super(key, value, ttl)
          @keys << key

          key_file = @directory / key

          file = File.new(key_file,'w')
          Marshal.dump(@cache[key], file)
          file.close
          @cache.delete key

        end
      end

      ##* delete(*keys) *##
      def delete(*keys)
        Waves.synchronize do

          keys.each do |key|
            if @keys.include? key
              File.delete(@directory / key)
              @keys.delete key
            else
              raise KeyMissing, "no key #{key} to delete"
            end
          end

        end
      end

      ##* clear *##
      def clear
        Waves.synchronize do

          @keys.each {|key| File.delete(@directory / key) }
          @keys.clear

        end
      end

      ##* fetch(key) *##
      def fetch(key)
        Waves.synchronize do

          raise KeyMissing, "#{key} doesn't exist" unless File.exists?(@directory / key)
          @cache[key] = Marshal.load File.new(@directory / key)
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