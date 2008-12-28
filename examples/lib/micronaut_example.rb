require File.expand_path(File.dirname(__FILE__) + "/../example_helper")

describe Micronaut do

  describe "#configuration" do
    
    it "should return an instance of Micronaut::Configuration" do
      Micronaut.configuration.should be_an_instance_of(Micronaut::Configuration)
    end
    
  end
  
  describe "#configure" do
    
    it "should yield the current configuration" do
      Micronaut.configure do |config|
        config.should == Micronaut.configuration
      end
    end
    
  end
  
  describe "#world" do
    
    it "should return the Micronaut::World instance the current run is using" do
      Micronaut.world.should be_instance_of(Micronaut::World)
    end
    
  end
  
  describe "InstallDirectory" do
    
    it "should be the expanded version of the install directory" do
      Micronaut::InstallDirectory.should == File.expand_path(File.dirname(__FILE__) + "/../../lib")
    end
    
  end
  
end
