require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe Micronaut::Runner do

  before do 
    @runner = Micronaut::Runner.new
  end

  describe '#configuration' do

    it "should return Micronaut.configuration" do
      @runner.configuration.should == Micronaut.configuration
    end

  end

  describe '#formatter' do

    it 'should return the configured formatter' do
      @runner.formatter.should == Micronaut.configuration.formatter
    end

  end  
  
  describe 'Micronaut::Runner.at_exit' do
    
    it 'should set an at_exit hook if none is already set' do
      Micronaut::Runner.stubs(:installed_at_exit?).returns(false)
      Micronaut::Runner.expects(:at_exit)
      Micronaut::Runner.autorun
    end
    
    it 'should not set the at_exit hook if it is already set' do
      Micronaut::Runner.stubs(:installed_at_exit?).returns(true)
      Micronaut::Runner.expects(:at_exit).never
      Micronaut::Runner.autorun
    end
    
  end
  
end