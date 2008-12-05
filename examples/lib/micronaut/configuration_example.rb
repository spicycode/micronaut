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
    
    module InstanceLevelMethods
      def you_call_this_a_blt?
        "egad man, where's the mayo?!?!?"
      end
    end
    
    it "should include the given module into each behaviour group" do
      Micronaut.configuration.include(InstanceLevelMethods)
      group = Micronaut::BehaviourGroup.describe(Object, 'does like, stuff and junk') { }
      group.should_not respond_to(:you_call_this_a_blt?)
      remove_last_describe_from_world

      group.new.you_call_this_a_blt?.should == "egad man, where's the mayo?!?!?"
    end
    
  end

  describe "#extend" do
    
    module FocusedSupport
      
      def fit(desc, options={}, &block)
        it(desc, options.merge(:focused => true), &block)
      end
      
    end
    
    it "should extend the given module into each behaviour group" do
      Micronaut.configuration.extend(FocusedSupport)
      group = Micronaut::BehaviourGroup.describe(FocusedSupport, 'the focused support ') { }
      group.should respond_to(:fit)
      remove_last_describe_from_world
    end
    
  end
  
end
