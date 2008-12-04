require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe Micronaut::Configuration do

  describe "#mock_with" do
    
    it "should include the mocha adapter when called with :mocha" do
      Micronaut::BehaviourGroup.expects(:send).with(:include, Micronaut::Mocking::WithMocha)
      Micronaut::Configuration.new.mock_with :mocha
    end
  
    it "should include the do absolutely nothing mocking adapter for all other cases" do
      Micronaut::BehaviourGroup.expects(:send).with(:include, Micronaut::Mocking::WithAbsolutelyNothing)
      Micronaut::Configuration.new.mock_with
    end
    
  end
  
  describe "#include" do
    
    module FakeModule; end
    
    it "should include the given module in Micronaut::BehaviourGroup" do
      Micronaut::BehaviourGroup.expects(:send).with(:include, FakeModule)
      Micronaut::Configuration.new.include(FakeModule)
    end
    
  end

  describe "#extend" do
    
    module FakeModule; end
    
    it "should extend the given module in Micronaut::BehaviourGroup" do
      Micronaut::BehaviourGroup.expects(:send).with(:extend, FakeModule)
      Micronaut::Configuration.new.extend(FakeModule)
    end
    
  end
  
end