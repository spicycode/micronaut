require 'spec_helper'

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
        isolate_behaviour do
          Micronaut::Behaviour.describe("my favorite pony") { }.name.should == 'my favorite pony'
        end
      end

      it "should call to_s on the first parameter in case it is a constant" do
        isolate_behaviour do
          Micronaut::Behaviour.describe(Object) { }.name.should == 'Object'
        end
      end

      pending "should build a nested name correctly, including the module, and each nested description in the correct order" do
        behaviour_to_test = nil

        isolate_behaviour do
          Micronaut::Behaviour.describe(Micronaut, "test") do
            Micronaut::Behaviour.describe("nested one") do
              behaviour_to_test = Micronaut::Behaviour.describe("nested two") { }
            end
          end
        end
        
        behaviour_to_test.name.should == 'Micronaut - test - nested one - nested two'
      end

    end

    describe '#describes' do

      it "should be the first parameter when it is a constant" do
        isolate_behaviour do
          Micronaut::Behaviour.describe(Object) { }.describes.should == Object
        end
      end

      it "should be nil when the first parameter is a string" do
        isolate_behaviour do
          Micronaut::Behaviour.describe("i'm a computer") { }.describes.should be_nil
        end
      end

    end

    describe '#description' do

      it "should expose the second parameter as description" do
        isolate_behaviour do
          Micronaut::Behaviour.describe(Object, "my desc") { }.description.should == 'my desc'
        end
      end

      it "should allow the second parameter to be nil" do
        isolate_behaviour do
          Micronaut::Behaviour.describe(Object, nil) { }.description.size.should == 0
        end
      end

    end

    describe '#metadata' do

      it "should add the third parameter to the metadata" do
        isolate_behaviour do
          Micronaut::Behaviour.describe(Object, nil, 'foo' => 'bar') { }.metadata.should include({ "foo" => 'bar' })
        end
      end

      it "should add the caller to metadata" do
        isolate_behaviour do
          Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:caller][4].should =~ /#{__FILE__}:#{__LINE__}/
        end
      end

      it "should add the the file_path to metadata" do
        isolate_behaviour do
          Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:file_path].should == __FILE__
        end
      end

      it "should have a reader for file_path" do
        isolate_behaviour do
          Micronaut::Behaviour.describe(Object) { }.file_path.should == __FILE__
        end
      end

      it "should add the line_number to metadata" do
        isolate_behaviour do
          Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:line_number].should == __LINE__
        end
      end

      it "should add file path and line number metadata for arbitrarily nested describes" do
        Micronaut::Behaviour.describe(Object) do
          Micronaut::Behaviour.describe("foo") do
            Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:file_path].should == __FILE__
            Micronaut::Behaviour.describe(Object) { }.metadata[:behaviour][:line_number].should == __LINE__
          end
        end

        4.times { remove_last_describe_from_world }
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

        group.before_eachs[0].call.should == 15
        group.before_eachs[1].call.should == 'A'
        group.before_eachs[2].call.should == 33.5
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

        group.before_alls[0].call.should == 15
        group.before_alls[1].call.should == 'A'
        group.before_alls[2].call.should == 33.5
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

        group.after_eachs[0].call.should == 15
        group.after_eachs[1].call.should == 'A'
        group.after_eachs[2].call.should == 33.5
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

        group.after_alls[0].call.should == 15
        group.after_alls[1].call.should == 'A'
        group.after_alls[2].call.should == 33.5
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

  describe Object, "describing nested behaviours", :little_less_nested => 'yep' do 

    describe "A sample nested describe", :nested_describe => "yep" do

      it "should set the described type to the constant Object" do
        running_example.behaviour.describes.should == Object
      end

      it "should set the description to 'A sample nested describe'" do
        running_example.behaviour.description.should == 'A sample nested describe'
      end

      it "should have top level metadata from the behaviour and its ancestors" do
        running_example.behaviour.metadata.should include(:little_less_nested => 'yep', :nested_describe => 'yep')
      end

      it "should make the parent metadata available on the contained examples" do
        running_example.metadata.should include(:little_less_nested => 'yep', :nested_describe => 'yep')
      end

    end

  end

  describe "#run_examples" do
    
    before do
      @fake_formatter = Micronaut::Formatters::BaseFormatter.new
    end

    def stub_behaviour
      stub_everything('behaviour', :metadata => { :behaviour => { :name => 'behaviour_name' }})
    end

    it "should return false if any of the examples return false" do
      use_formatter(@fake_formatter) do
        failing_example = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 2 }))
        passing_example = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 1 }))
        Micronaut::Behaviour.stubs(:examples_to_run).returns([failing_example, passing_example])

        Micronaut::Behaviour.run_examples(stub_behaviour, stub_everything('reporter')).should be_false
      end
    end

    it "should run all examples, regardless of any of them failing" do
      use_formatter(@fake_formatter) do
        failing_example = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 2 }))
        passing_example = Micronaut::Example.new(stub_behaviour, 'description', {}, (lambda { 1.should == 1 }))
        Micronaut::Behaviour.stubs(:examples_to_run).returns([failing_example, passing_example])

        passing_example.expects(:run)

        Micronaut::Behaviour.run_examples(stub_behaviour, stub_everything('reporter'))
      end
    end

  end
  
  describe "how instance variables inherit" do
    
    before(:all) do
      @before_all_top_level = 'before_all_top_level'
    end

    before(:each) do
      @before_each_top_level = 'before_each_top_level'
    end
    
    it "should be able to access a before each ivar at the same level" do
      @before_each_top_level.should == 'before_each_top_level'
    end
    
    it "should be able to access a before all ivar at the same level" do
      @before_all_top_level.should == 'before_all_top_level'
    end


    it "should be able to access the before all ivars in the before_all_ivars hash" do
      with_ruby('1.8') do
        running_example.behaviour.before_all_ivars.should include('@before_all_top_level' => 'before_all_top_level')
      end
      with_ruby('1.9') do
        running_example.behaviour.before_all_ivars.should include(:@before_all_top_level => 'before_all_top_level')
      end
    end
    
    describe "but now I am nested" do
      
      it "should be able to access a parent behaviours before each ivar at a nested level" do
        @before_each_top_level.should == 'before_each_top_level'
      end
      
      it "should be able to access a parent behaviours before all ivar at a nested level" do
        @before_all_top_level.should == "before_all_top_level"
      end

      it "changes to before all ivars from within an example do not persist outside the current describe" do
        @before_all_top_level = "ive been changed"
      end

      describe "accessing a before_all ivar that was changed in a parent behaviour" do
        
        it "should have access to the modified version" do
          @before_all_top_level.should == 'ive been changed'
        end

      end
      
    end
    
  end

end
