# require 'test_helper' because RubyMate needs help
require "#{File.dirname(__FILE__)}/../../helpers"
require 'layers/orm/sequel'

clear_all_apps
module TestApplication
  include AutoCode
  module Configurations
    class Development
      stub!(:database).and_return(:adapter => 'sqlite',
				  :database => "#{File.dirname(__FILE__)}test.db")
    end
  end
  
  include Waves::Layers::ORM::Sequel
end

Waves.stub!(:config).and_return(TestApplication::Configurations::Development)

Waves << TestApplication

TA = TestApplication

describe "An application module which includes the Sequel ORM layer" do
  
  wrap { rm_if_exist 'test.db' }
    
  it "auto_creates models that inherit from Sequel::Model" do
    TA::Models::Default.superclass.should == Sequel::Model
    TA::Models::Thingy.superclass.should == TA::Models::Default
  end
  
  it "sets the dataset to use the snake_case of the class name as the table name" do
    TA::Models::Thingy.dataset.send(:to_table_reference).should =~ /SELECT.+FROM.+thingies+/
  end
  
  it "provides an accessor for database" do
    TA.should.respond_to :database
  end
  
end

