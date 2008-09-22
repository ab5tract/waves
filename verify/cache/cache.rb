require File.join(File.dirname(__FILE__) , "helpers")

include Cache::Helpers

describe "Waves::Cache" do

  before do
    @cache = Waves::Cache.new
    fill_cache @cache
  end

  it "can find a value in the cache" do
    @cache[:key1].should == "value1"
  end

  it "has members who obey their time-to-live" do
    ttl_test @cache
  end


  it "can delete a value from the cache" do
    delete_test @cache
  end

  it "can delete multiple values from the cache" do
    multi_delete_test @cache
  end
  
  it "can clear the cache" do
    clear_test @cache
  end

end