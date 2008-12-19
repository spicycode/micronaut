require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe Micronaut::Example do

  before do
    behaviour = stub('behaviour', :name => 'behaviour_name')
    @example = Micronaut::Example.new(behaviour, 'description', {}, (lambda {}))
  end
  
  describe "attr readers" do
  
    it "should have one for the parent behaviour" do
      @example.should respond_to(:behaviour)
    end
  
    it "should have one for it's description" do
      @example.should respond_to(:description)
    end
  
    it "should have one for it's options" do
      @example.should respond_to(:options)
    end
  
    it "should have one for it's block" do
      @example.should respond_to(:example_block)
    end

  end
  
  describe '#inspect' do
    
    it "should return 'behaviour_name - description'" do
      @example.inspect.should == 'behaviour_name - description'
    end
    
  end
  
  describe '#to_s' do
    
    it "should return #inspect" do
      @example.to_s.should == @example.inspect
    end
    
  end
  
  describe "accessing metadata within a running example" do

    it "should have a reference to itself when running" do
      running_example.description.should == "should have a reference to itself when running"
    end
  
  end
  
end
