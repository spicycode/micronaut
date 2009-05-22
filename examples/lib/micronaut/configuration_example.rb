require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe Micronaut::Configuration do

  describe "#mock_with" do

    it "should require and include the mocha adapter when called with :mocha" do
      Micronaut.configuration.expects(:require).with('micronaut/mocking/with_mocha')
      Micronaut::Behaviour.expects(:send)
      Micronaut.configuration.mock_with :mocha
    end

    it "should include the null adapter for nil" do
      Micronaut::Behaviour.expects(:send).with(:include, Micronaut::Mocking::WithAbsolutelyNothing)
      Micronaut.configuration.mock_with nil
    end
    
    # if the below example doesn't pass, @behaviour_instance._setup_mocks and similiar calls fail without a mock library specified
    # this is really a case where cucumber would be a better fit to catch these type of regressions
    it "should include the null adapter by default, if no mocking library is specified" do
      Micronaut::Behaviour.expects(:send).with(:include, Micronaut::Mocking::WithAbsolutelyNothing)
      config = Micronaut::Configuration.new
    end
    
  end  
 
  describe "#include" do

    module InstanceLevelMethods
      def you_call_this_a_blt?
        "egad man, where's the mayo?!?!?"
      end
    end

    it "should include the given module into each matching behaviour" do
      Micronaut.configuration.include(InstanceLevelMethods, :magic_key => :include)
      group = Micronaut::Behaviour.describe(Object, 'does like, stuff and junk', :magic_key => :include) { }
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

    it "should extend the given module into each matching behaviour" do
      Micronaut.configuration.extend(ThatThingISentYou, :magic_key => :extend)      
      group = Micronaut::Behaviour.describe(ThatThingISentYou, :magic_key => :extend) { }
      
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
  
  describe '#trace?' do
    
    it "is false by default" do
      Micronaut::Configuration.new.trace?.should == false
    end
    
    it "is true if configuration.trace is true" do
      config = Micronaut::Configuration.new
      config.trace = true
      config.trace?.should == true
    end
    
  end
  
  describe '#trace' do
    
    it "requires a block" do
      config = Micronaut::Configuration.new
      config.trace = true
      lambda { config.trace(true) }.should raise_error(ArgumentError)
    end
    
    it "does nothing if trace is false" do
      config = Micronaut::Configuration.new
      config.trace = false
      config.expects(:puts).with("my trace string is awesome").never
      config.trace { "my trace string is awesome" }
    end
    
    it "allows overriding tracing an optional param" do
      config = Micronaut::Configuration.new
      config.trace = false
      config.expects(:puts).with(includes("my trace string is awesome"))
      config.trace(true) { "my trace string is awesome" }
    end
       
  end
  
  describe '#formatter' do

    it "sets formatter_to_use based on name" do
      config = Micronaut::Configuration.new
      config.formatter = :documentation
      config.instance_eval { @formatter_to_use.should == Micronaut::Formatters::DocumentationFormatter }
      config.formatter = 'documentation'
      config.instance_eval { @formatter_to_use.should == Micronaut::Formatters::DocumentationFormatter }
    end
    
    it "raises ArgumentError if formatter is unknown" do
      config = Micronaut::Configuration.new
      lambda { config.formatter = :progresss }.should raise_error(ArgumentError)
    end
    
  end

  describe "filters" do
    
    it "tells you filter is deprecated"
    
    it "responds to exclusion_filter"
    
    it "responds to inclusion_filter"
    
    
  end
end
