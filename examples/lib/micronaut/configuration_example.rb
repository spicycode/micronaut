require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe Micronaut::Configuration do

  describe "#mock_with" do

    it "should require and include the mocha adapter when called with :mocha" do
      Micronaut.configuration.expects(:require).with('micronaut/mocking/with_mocha')
      Micronaut::Behaviour.expects(:send)
      Micronaut.configuration.mock_with :mocha
    end

    it "should include the do absolutely nothing mocking adapter for all other cases" do
      Micronaut::Behaviour.expects(:send).with(:include, Micronaut::Mocking::WithAbsolutelyNothing)
      Micronaut.configuration.mock_with
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
      group = Micronaut::Behaviour.describe(Object, 'does like, stuff and junk') { }
      group.should_not respond_to(:you_call_this_a_blt?)
      remove_last_describe_from_world

      group.new.you_call_this_a_blt?.should == "egad man, where's the mayo?!?!?"
    end

  end

  describe "#extend" do

    module ThatThingISentYou

      def that_thing
      end

    end

    it "should extend the given module into each behaviour group" do
      Micronaut.configuration.extend(ThatThingISentYou)
      group = Micronaut::Behaviour.describe(ThatThingISentYou) { }
      group.should respond_to(:that_thing)
      remove_last_describe_from_world
    end

  end

  describe "#run_all_when_everything_filtered" do

    it "defaults to true" do
      Micronaut::Configuration.new.run_all_when_everything_filtered.should == true
    end

    it "can be queried with question method" do
      config = Micronaut::Configuration.new
      config.run_all_when_everything_filtered = false
      config.run_all_when_everything_filtered?.should == false
    end
  end

end
