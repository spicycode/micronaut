require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe Micronaut::ExampleGroup do
  class Foo
    include Mocha::Standalone
  end  
  
  it "should do something" do
    foo = Foo.new
    foo.respond_to?(:mock).should == true
    eg = Micronaut::ExampleGroup.new
    eg.respond_to?(:mock).should == true
    
    
    eg_class = Micronaut::ExampleGroup.describe(Foo) { }
    eg = eg_class.new
    # eg.methods(true).grep(/mock|stub/).should == 'foo'
    eg.respond_to?(:mock).should == true
  end
  

  
  def scenario_1
    example_group = Micronaut::ExampleGroup.describe(Foo, "Scenario 1") do 
      it("should do 1 thing") { 1 } 
      it("should do 2 thing") { 2 } 
      it("should do 3 thing") { 3 }     
    end
    example_group
  end
  
  def scenario_2
    example_group = Micronaut::ExampleGroup.describe(Foo, "Scenario 2") do
      before { 'beforeeach1' }
      before { 'beforeeach2' }
      before(:all) { 'beforeall1' }
      before(:all) { 'beforeall2' }
    end
    example_group
  end
  
  def scenario_3
    example_group = Micronaut::ExampleGroup.describe(Foo, "Scenario 3") do
      after { 'aftereach1' }
      after { 'aftereach2' }
      after(:all) { 'afterall1' }
      after(:all) { 'afterall2' }
    end
    example_group
  end
  
  it "should make the first parameter the name by calling to_s on it" do
    scenario_1.name.should == 'Foo'
  end
  
    it "should make the second parameter the description" do
      scenario_1.description.should == 'Scenario 1'
    end
    
    it "scenario 1 should have 3 examples" do
      scenario_1.should have(3).examples
    end
    
    it "scenario 1 should maintain the example order" do
      example_group = scenario_1
      example_group.examples[0].first.should == 'should do 1 thing'
      example_group.examples[1].first.should == 'should do 2 thing'
      example_group.examples[2].first.should == 'should do 3 thing'
    end
    
    it "scenario 1 should allow you to call it's examples" do
      example_group = scenario_1
      example_group.examples[0].last.call.should == 1
      example_group.examples[1].last.call.should == 2
      example_group.examples[2].last.call.should == 3
    end
    
    it "scenario 2 should have 2 before eachs" do
      scenario_2.should have(2).before_eachs
    end
    
    it "scenario 2 should have 2 before all" do
      scenario_2.should have(2).before_alls
    end
    
    it "scenario 2 should maintain the before each order" do
      example_group = scenario_2
      example_group.before_alls[0].call.should == 'beforeall1'
      example_group.before_alls[1].call.should == 'beforeall2'
      example_group.before_eachs[0].call.should == 'beforeeach1'
      example_group.before_eachs[1].call.should == 'beforeeach2'
    end
    
    it "scenario 3 should have 2 after eachs" do
      scenario_3.should have(2).after_eachs
    end
    
    it "scenario 3 should have 2 after alls" do
      scenario_3.should have(2).after_alls
    end
    
    it "scenario 3 should maintain the after block order" do
      example_group = scenario_3
      example_group.after_alls[0].call.should == 'afterall1'
      example_group.after_alls[1].call.should == 'afterall2'
      example_group.after_eachs[0].call.should == 'aftereach1'
      example_group.after_eachs[1].call.should == 'aftereach2'
    end
    
end
