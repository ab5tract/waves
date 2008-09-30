module Waves
  module Caches

    class File < Waves::Caches::Hash

      def initialize(arg)
        raise ArgumentError, ":dir needs to not be nil" if arg[:dir].nil?
        @directory = arg[:dir]
        @keys = []
      end

      def store(key, value, ttl = nil)            
        key_file = @directory / key
        item = {:value => value}
        item[:expires] = Time.now + ttl   if ttl

        Waves.synchronize do
          @keys << key
          file = ::File.new(key_file,'w')
          Marshal.dump(item, file)
          file.close
        end
      end

      def delete(*keys)
        Waves.synchronize do
          keys.each do |key|
            if @keys.include? key
              ::File.delete(@directory / key)
              @keys.delete key; nil														# return nil
            end
          end
        end
      end

      def clear
        Waves.synchronize do
          @keys.each {|key| ::File.delete(@directory / key) }
          @keys.clear
        end
      end

      def fetch(key)
        Waves.synchronize do

          item = ::Marshal.load(::File.new(@directory / key))

          if item[:expires] and item[:expires] < Time.now
            ::File.delete(@directory / key)
            @keys.delete key
          end
          item[:value]
        end
      end

    end
    
  end
end


