require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe Micronaut::Behaviour do

  def empty_behaviour_group
    group = Micronaut::Behaviour.describe(Object, 'Empty Behaviour Group') { }
    remove_last_describe_from_world
  end

  describe "describing behaviour with #describe" do

    example "an ArgumentError is raised if no type or description is given" do
      lambda { Micronaut::Behaviour.describe() {} }.should raise_error(ArgumentError, "No arguments given.  You must a least supply a type or description")
    end

    example "an ArgumentError is raised if no block is given" do
      lambda { Micronaut::Behaviour.describe('foo') }.should raise_error(ArgumentError, "You must supply a block when calling describe")
    end

    describe '#name' do

      it "should expose the first parameter as name" do
        Micronaut::Behaviour.describe("my favorite pony") { }.name.should == 'my favorite pony'
      end

      it "should call to_s on the first parameter in case it is a constant" do
        Micronaut::Behaviour.describe(Object) { }.name.should == 'Object'
      end

    end

    describe '#describes' do

      it "should be the first parameter when it is a constant" do
        Micronaut::Behaviour.describe(Object) { }.describes.should == Object
      end

      it "should be nil when the first parameter is a string" do
        Micronaut::Behaviour.describe("i'm a computer") { }.describes.should be_nil
      end

    end

    describe '#description' do

      it "should expose the second parameter as description" do
        Micronaut::Behaviour.describe(Object, "my desc") { }.description.should == 'my desc'
      end
      
      it "should allow the second parameter to be nil" do
        Micronaut::Behaviour.describe(Object, nil) { }.description.size.should == 0
      end

    end

    describe '#metadata' do
      
      it "should add the third parameter to the metadata" do
        Micronaut::Behaviour.describe(Object, nil, 'foo' => 'bar') { }.metadata.should include({ "foo" => 'bar' })
      end
      
      it "should add the caller to metadata" do
        Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:caller].should include("#{__FILE__}:#{__LINE__}")
      end
      
      it "should add the the file_path to metadata" do
        Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:file_path].should == __FILE__
      end
      
      it "should have a reader for file_path" do
        Micronaut::Behaviour.describe(Object) { }.file_path.should == __FILE__
      end
      
      it "should add the line_number to metadata" do
        Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:line_number].should == __LINE__
      end
      
      it "should add file path and line number metadata for arbitrarily nested describes" do
        Micronaut::Behaviour.describe(Object) do
          Micronaut::Behaviour.describe("foo") do
            Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:file_path].should == __FILE__
            Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:line_number].should == __LINE__
          end
        end
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

  describe Object, "describing nested behaviours" do 

    describe "A sample nested describe", :just_testing => 'yep' do
    
      it "should set the described type to the constant Object" do
        running_example.behaviour.describes.should == Object
      end
      
      it "should set the description to 'A sample nested describe'" do
        running_example.behaviour.description.should == 'A sample nested describe'
      end
      
      it "should have :just_testing => 'yep' in the metadata" do
        running_example.behaviour.metadata.should include(:just_testing => 'yep')
      end

    end

  end
  
  describe "#run_examples" do
    
    def stub_behaviour
      stub_everything('behaviour', :metadata => { :behaviour => { :name => 'behaviour_name' }})
    end

    it "should return true if all examples pass" do
      passing_example1 = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 1 }))
      passing_example2 = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 1 }))
      Micronaut::Behaviour.stubs(:examples_to_run).returns([passing_example1, passing_example2])

      Micronaut::Behaviour.run_examples(stub_behaviour, stub_everything('reporter')).should == true
    end
    
    it "should return false if any of the examples return false" do
      failing_example = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 2 }))
      passing_example = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 1 }))
      Micronaut::Behaviour.stubs(:examples_to_run).returns([failing_example, passing_example])

      Micronaut::Behaviour.run_examples(stub_behaviour, stub_everything('reporter')).should == false
    end
    
    it "should run all examples, regardless of any of them failing" do
      failing_example = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 2 }))
      passing_example = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 1 }))
      Micronaut::Behaviour.stubs(:examples_to_run).returns([failing_example, passing_example])

      passing_example.expects(:run)
      
      Micronaut::Behaviour.run_examples(stub_behaviour, stub_everything('reporter'))
    end
    
  end
  
end
