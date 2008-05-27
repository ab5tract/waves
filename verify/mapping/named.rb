# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

specification "A developer can register named mappings" do

  before do
    mapping.clear
    resource = /([\w\-]+)/
    name = /([\w\-\_\.\+\@]+)/
    path '/{resource}/{name}', :named => :show do
        "Works"
      end
  end

  specify "accessible via Waves.mapping.named" do
    
    Waves.mapping.named.show( :resource => "foo", :name => "bar").should == "/foo/bar"
    
  end
  
  specify "accessible via Application.paths" do
    
    Test.paths.show( :resource => "foo", :name => "bar").should == "/foo/bar"
    
  end


end