
module Waves

  module Caches

    # Looks barebones in here, huh?
    # That's because the Waves::Cache API is implemented in a separate file.
    require 'caches/hash'

    def self.new
      Waves::Caches::Hash.new
    end

    def self.list
      # puts the whole symbol list of the available namespace.
    end

    
  end
end