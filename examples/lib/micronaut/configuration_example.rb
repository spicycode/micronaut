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

end