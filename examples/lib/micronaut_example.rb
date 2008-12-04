require File.expand_path(File.dirname(__FILE__) + "/../example_helper")

describe Micronaut do

  describe "configuration" do
    
    it "should return an instance of Micronaut::Configuration" do
      Micronaut.configuration.should be_an_instance_of(Micronaut::Configuration)
    end
    
  end
  
  describe "configure" do
    
    it "should yield the current configuration" do
      Micronaut.configure do |config|
        config.should == Micronaut.configuration
      end
    end
    
  end
  
end