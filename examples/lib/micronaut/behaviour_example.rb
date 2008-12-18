require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe Micronaut::Behaviour do

  class Foo

  end  

  def empty_behaviour_group
    group = Micronaut::Behaviour.describe(Foo, 'Empty Behaviour Group') { }
    remove_last_describe_from_world
  end

  describe "describing behaviour with #describe" do

    it "should raise an ArgumentError if no name is given" do
      lambda { Micronaut::Behaviour.describe() {} }.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no block is given" do
      lambda { Micronaut::Behaviour.describe('foo') }.should raise_error(ArgumentError)
    end

    describe '#name' do

      it "should expose the first parameter as name" do
        Micronaut::Behaviour.describe("my favorite pony") { }.name.should == 'my favorite pony'
      end

      it "should call to_s on the first parameter in case it is a constant" do
        Micronaut::Behaviour.describe(Foo) { }.name.should == 'Foo'
      end

    end

    describe '#described_type' do

      it "should be the first parameter when it is a constant" do
        Micronaut::Behaviour.describe(Foo) { }.described_type.should == Foo
      end

      it "should be nil when the first parameter is a string" do
        Micronaut::Behaviour.describe("i'm a computer") { }.described_type.should be_nil
      end

    end

    describe '#description' do

      it "should expose the second parameter as description" do
        Micronaut::Behaviour.describe(Foo, "my desc") { }.description.should == 'my desc'
      end

      it "should allow the second parameter to be nil" do
        Micronaut::Behaviour.describe(Foo, nil) { }.description.size.should == 0
      end

    end

    describe '#options' do

      it "should expose the third parameter as options" do
        Micronaut::Behaviour.describe(Foo, nil, 'foo' => 'bar') { }.options.should == { "foo" => 'bar' }
      end

      it "should be an empty hash if no options are supplied" do
        Micronaut::Behaviour.describe(Foo, nil) { }.options.should == {}
      end

    end

    describe "adding before and after hooks" do

      it "should expose the before each blocks at before_eachs" do
        group = empty_behaviour_group
        group.before(:each) { 'foo' }
        group.should have(1).before_eachs
      end

      it "should maintain the before each block order" do
        group = empty_behaviour_group 
        group.before(:each) { 15 }
        group.before(:each) { 'A' }
        group.before(:each) { 33.5 }

        group.before_eachs[0].last.call.should == 15
        group.before_eachs[1].last.call.should == 'A'
        group.before_eachs[2].last.call.should == 33.5
      end

      it "should expose the before all blocks at before_alls" do
        group = empty_behaviour_group
        group.before(:all) { 'foo' }
        group.should have(1).before_alls
      end

      it "should maintain the before all block order" do
        group = empty_behaviour_group 
        group.before(:all) { 15 }
        group.before(:all) { 'A' }
        group.before(:all) { 33.5 }

        group.before_alls[0].last.call.should == 15
        group.before_alls[1].last.call.should == 'A'
        group.before_alls[2].last.call.should == 33.5
      end

      it "should expose the after each blocks at after_eachs" do
        group = empty_behaviour_group
        group.after(:each) { 'foo' }
        group.should have(1).after_eachs
      end

      it "should maintain the after each block order" do
        group = empty_behaviour_group 
        group.after(:each) { 15 }
        group.after(:each) { 'A' }
        group.after(:each) { 33.5 }

        group.after_eachs[0].last.call.should == 15
        group.after_eachs[1].last.call.should == 'A'
        group.after_eachs[2].last.call.should == 33.5
      end

      it "should expose the after all blocks at after_alls" do
        group = empty_behaviour_group
        group.after(:all) { 'foo' }
        group.should have(1).after_alls
      end

      it "should maintain the after each block order" do
        group = empty_behaviour_group 
        group.after(:all) { 15 }
        group.after(:all) { 'A' }
        group.after(:all) { 33.5 }

        group.after_alls[0].last.call.should == 15
        group.after_alls[1].last.call.should == 'A'
        group.after_alls[2].last.call.should == 33.5
      end

    end

    describe "adding examples" do

      it "should allow adding an example using 'it'" do
        group = empty_behaviour_group
        group.it("should do something") { }
        group.examples.size.should == 1
      end

      it "should expose all examples at examples" do
        group = empty_behaviour_group
        group.it("should do something 1") { }
        group.it("should do something 2") { }
        group.it("should do something 3") { }
        group.examples.size.should == 3
      end

      it "should maintain the example order" do
        group = empty_behaviour_group
        group.it("should 1") { }
        group.it("should 2") { }
        group.it("should 3") { }
        group.examples[0].description.should == 'should 1'
        group.examples[1].description.should == 'should 2'
        group.examples[2].description.should == 'should 3'
      end

    end

  end

  describe Foo, "describing nested behaviours" do 

    describe "nested describes" do
    
      it "should set the described type to the parent described type if no described type is given" do
        self.class.described_type.should == Foo
      end
      
      it "should set the description to the first parameter if no described type is given" do
        self.class.description.should == 'nested describes'
      end

      it "should have access to all of it's ancestors before blocks" 
      
      it "should have access to all of it's ancestors after blocks"

    end

  end

end