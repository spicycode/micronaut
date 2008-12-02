require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

class Bar; end

describe Micronaut::World do


  describe "behaviour groups" do

    it "should contain all defined behaviour groups" do
      behaviour_group = Micronaut::BehaviourGroup.describe(Bar, 'Empty Behaviour Group') { }
      Micronaut::World.behaviour_groups.should include(behaviour_group)       
      remove_last_describe_from_world
    end

  end

  describe "find" do

    before(:all) do
      options_1 = { :foo => 1, :color => 'blue', :feature => 'reporting' }
      options_2 = { :pending => true, :feature => 'reporting'  }
      options_3 = { :array => [1,2,3,4], :color => 'blue', :feature => 'weather status' }      
      @bg1 = Micronaut::BehaviourGroup.describe(Bar, "find group-1", options_1) { }
      @bg2 = Micronaut::BehaviourGroup.describe(Bar, "find group-2", options_2) { }
      @bg3 = Micronaut::BehaviourGroup.describe(Bar, "find group-3", options_3) { }
    end

    after(:all) do
      Micronaut::World.behaviour_groups.delete(@bg1)
      Micronaut::World.behaviour_groups.delete(@bg2)
      Micronaut::World.behaviour_groups.delete(@bg3)
    end
    
    it "should find no groups when given no search parameters" do
      Micronaut::World.find.should == []
    end
  
    it "should find three groups when searching for :described_type => Bar" do
      Micronaut::World.find(:described_type => Bar).should == [@bg1, @bg2, @bg3]
    end
    
    it "should find one group when searching for :description => 'find group-1'" do
      Micronaut::World.find(:description => 'find group-1').should == [@bg1]
    end
    
    it "should find two groups when searching for :description => lambda { |v| v.include?('-1') || v.include?('-3') }" do
      Micronaut::World.find(:description => lambda { |v| v.include?('-1') || v.include?('-3') }).should == [@bg1, @bg3]
    end
    
    it "should find three groups when searching for :description => /find group/" do
      Micronaut::World.find(:description => /find group/).should == [@bg1, @bg2, @bg3]
    end

    
    it "should find one group when searching for :options => { :foo => 1 }" do
      Micronaut::World.find(:options => { :foo => 1 }).should == [@bg1]
    end
    
    it "should find one group when searching for :options => { :pending => true }" do
      Micronaut::World.find(:options => { :pending => true }).should == [@bg2]
    end

    it "should find one group when searching for :options => { :array => [1,2,3,4] }" do
      Micronaut::World.find(:options => { :array => [1,2,3,4] }).should == [@bg3]
    end

    it "should find no group when searching for :options => { :array => [4,3,2,1] }" do
      Micronaut::World.find(:options => { :array => [4,3,2,1] }).should be_empty
    end    

    it "should find two groups when searching for :options => { :color => 'blue' }" do
      Micronaut::World.find(:options => { :color => 'blue' }).should == [@bg1, @bg3]
    end

    it "should find two groups when searching for :options => { :feature => 'reporting' }" do
      Micronaut::World.find(:options => { :feature => 'reporting' }).should == [@bg1, @bg2]
    end

    it "should find two groups when searching for :options => { :feature => 'reporting' }" do
      Micronaut::World.find(:options => { :feature => 'reporting' }).should == [@bg1, @bg2]
    end
    
  end

  describe "reset" do

    it "should clear the list of behaviour groups" do
      original_groups = Micronaut::World.behaviour_groups

      Micronaut::World.behaviour_groups.should_not be_empty
      Micronaut::World.reset
      Micronaut::World.behaviour_groups.should be_empty

      Micronaut::World.behaviour_groups.concat(original_groups)
    end

  end

end