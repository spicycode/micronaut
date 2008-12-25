require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

class Bar; end
class Foo; end

describe Micronaut::World do
  
  before do
    @world = Micronaut::World.new
    Micronaut.stubs(:world).returns(@world)
  end

  describe "behaviour groups" do

    it "should contain all defined behaviour groups" do
      behaviour_group = Micronaut::Behaviour.describe(Bar, 'Empty Behaviour Group') { }
      @world.behaviours.should include(behaviour_group)       
    end

  end

  describe "find" do

    before(:all) do
      options_1 = { :foo => 1, :color => 'blue', :feature => 'reporting' }
      options_2 = { :pending => true, :feature => 'reporting'  }
      options_3 = { :array => [1,2,3,4], :color => 'blue', :feature => 'weather status' }      
      @bg1 = Micronaut::Behaviour.describe(Bar, "find group-1", options_1) { }
      @bg2 = Micronaut::Behaviour.describe(Bar, "find group-2", options_2) { }
      @bg3 = Micronaut::Behaviour.describe(Bar, "find group-3", options_3) { }
      @bg4 = Micronaut::Behaviour.describe(Foo, "find these examples") do
        it('I have no options') {}
        it("this is awesome", :awesome => true) {}
        it("this is too", :awesome => true) {}
        it("not so awesome", :awesome => false) {}
        it("I also have no options") {}
      end
      @behaviours = [@bg1, @bg2, @bg3, @bg4]
    end
    
    after(:all) do
      Micronaut.world.behaviours.delete(@bg1)
      Micronaut.world.behaviours.delete(@bg2)
      Micronaut.world.behaviours.delete(@bg3)
      Micronaut.world.behaviours.delete(@bg4)
    end

    it "should find awesome examples" do
      @world.find(@bg4.examples, :awesome => true).should == [@bg4.examples[1], @bg4.examples[2]]
    end
    
    it "should find no groups when given no search parameters" do
      @world.find([]).should == []
    end
  
    it "should find three groups when searching for :behaviour_describes => Bar" do
      @world.find(@behaviours, :behaviour => { :describes => Bar }).should == [@bg1, @bg2, @bg3]
    end
    
    it "should find one group when searching for :description => 'find group-1'" do
      @world.find(@behaviours, :behaviour => { :description => 'find group-1' }).should == [@bg1]
    end
    
    it "should find two groups when searching for :description => lambda { |v| v.include?('-1') || v.include?('-3') }" do
      @world.find(@behaviours, :behaviour => { :description => lambda { |v| v.include?('-1') || v.include?('-3') } }).should == [@bg1, @bg3]
    end
    
    it "should find three groups when searching for :description => /find group/" do
      @world.find(@behaviours, :behaviour => { :description => /find group/ }).should == [@bg1, @bg2, @bg3]
    end
    
    it "should find one group when searching for :foo => 1" do
      @world.find(@behaviours, :foo => 1 ).should == [@bg1]
    end
    
    it "should find one group when searching for :pending => true" do
      @world.find(@behaviours, :pending => true ).should == [@bg2]
    end

    it "should find one group when searching for :array => [1,2,3,4]" do
      @world.find(@behaviours, :array => [1,2,3,4]).should == [@bg3]
    end

    it "should find no group when searching for :array => [4,3,2,1]" do
      @world.find(@behaviours, :array => [4,3,2,1]).should be_empty
    end    

    it "should find two groups when searching for :color => 'blue'" do
      @world.find(@behaviours, :color => 'blue').should == [@bg1, @bg3]
    end

    it "should find two groups when searching for :feature => 'reporting' }" do
      @world.find(@behaviours, :feature => 'reporting').should == [@bg1, @bg2]
    end

  end

end