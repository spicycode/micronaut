require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe Micronaut::ExampleGroup do
  class Foo; end
  
  def scenario_1
    example_group = Micronaut::ExampleGroup.new(Foo, "Scenario 1")
    example_group.it("should do 1 thing") { 1 } 
    example_group.it("should do 2 thing") { 2 } 
    example_group.it("should do 3 thing") { 3 } 
    example_group
  end

  def scenario_2
    example_group = Micronaut::ExampleGroup.new(Foo, "Scenario 2")
    example_group.before { 'beforeeach1' }
    example_group.before { 'beforeeach2' }
    example_group.before(:all) { 'beforeall1' }
    example_group.before(:all) { 'beforeall2' }
    example_group
  end

  def scenario_3
    example_group = Micronaut::ExampleGroup.new(Foo, "Scenario 3")
    example_group.after { 'aftereach1' }
    example_group.after { 'aftereach2' }
    example_group.after(:all) { 'afterall1' }
    example_group.after(:all) { 'afterall2' }
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

  it "scenario 2 should have 2 before each parts" do
    scenario_2.should have(2).before_each_parts
  end

  it "scenario 2 should have 2 before all parts" do
    scenario_2.should have(2).before_all_parts
  end

  it "scenario 2 should maintain the before parts order" do
    example_group = scenario_2
    example_group.before_all_parts[0].call.should == 'beforeall1'
    example_group.before_all_parts[1].call.should == 'beforeall2'
    example_group.before_each_parts[0].call.should == 'beforeeach1'
    example_group.before_each_parts[1].call.should == 'beforeeach2'
  end

  it "scenario 3 should have 2 after each parts" do
    scenario_3.should have(2).after_each_parts
  end

  it "scenario 3 should have 2 after all parts" do
    scenario_3.should have(2).after_all_parts
  end

  it "scenario 3 should maintain the after parts order" do
    example_group = scenario_3
    example_group.after_all_parts[0].call.should == 'afterall1'
    example_group.after_all_parts[1].call.should == 'afterall2'
    example_group.after_each_parts[0].call.should == 'aftereach1'
    example_group.after_each_parts[1].call.should == 'aftereach2'
  end

  def scenario_4
    example_group = Micronaut::ExampleGroup.new(Foo, "Scenario 4")
    example_group
  end

  it "scenario 4 should run the before all blocks, before each blocks, the example, the after each blocks, and finally the after all blocks" do
    example_group = scenario_4
    example_group.before(:all) { 'before_all_1' }
    example_group.before(:all) { 'before_all_2' }
    example_group.before { "before_each_1"; @foo = 2 }
    example_group.before { "before_each_2"; @foo += 1 }
    example_group.before { "before_each_3"; @foo += 2 }
    example_group.after { "after_each_1"; @foo = 3 }
    example_group.after { "after_each_2"; 'final after each' }
    example_group.after(:all) { 'after_all_1' }
    example_group.after(:all) { 'after_all_2' }

    example_group.it("prints out the value of the @foo variable") do
      @foo.should == 5
    end
    example_group.it("other example") do

    end
    example_group.run
  end

end
