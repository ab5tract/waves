# require 'test_helper' because RubyMate needs help
require "#{File.dirname(__FILE__)}/helpers"
require 'foundations/compact'

clear_all_apps
module CompactApplication ; include Waves::Foundations::Compact ; end

describe "An application module which includes the Simple foundation" do

  it "should have basic submodules defined" do
    lambda do
      CompactApplication::Configurations::Development
      CompactApplication::Resources::Map
    end.should.not.raise
  end

end
