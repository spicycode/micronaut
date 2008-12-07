require File.expand_path(File.dirname(__FILE__) + "/../../../../example_helper")

describe Object do

  describe "#should" do

    before do
      @target = "target"
      @matcher = mock("matcher")
      @matcher.stubs(:matches?).returns(true)
      @matcher.stubs(:failure_message)
    end

    it "should accept and interact with a matcher" do
      @matcher.expects(:matches?).with(@target).returns(true)    
      @target.should @matcher
    end

    it "should ask for a failure_message when matches? returns false" do
      @matcher.expects(:matches?).with(@target).returns(false)
      @matcher.expects(:failure_message).returns("the failure message")
      lambda { @target.should @matcher }.should fail_with("the failure message")
    end

    it "should raise error if it receives false directly" do
      lambda { @target.should false }.should raise_error(Micronaut::Expectations::InvalidMatcherError)
    end

    it "should raise error if it receives false (evaluated)" do
      lambda { @target.should eql?("foo") }.should raise_error(Micronaut::Expectations::InvalidMatcherError)
    end

    it "should raise error if it receives true" do
      lambda { @target.should true }.should raise_error(Micronaut::Expectations::InvalidMatcherError)
    end

  end

  describe "#should_not" do

    before do
      @target = "target"
      @matcher = mock("matcher")
    end

    it "should accept and interact with a matcher" do
      @matcher.expects(:matches?).with(@target).returns(false)
      @matcher.stubs(:negative_failure_message)
      @target.should_not @matcher
    end

    it "should ask for a negative_failure_message when matches? returns true" do
      @matcher.expects(:matches?).with(@target).returns(true)
      @matcher.expects(:negative_failure_message).returns("the negative failure message")
      lambda { @target.should_not @matcher }.should fail_with("the negative failure message")
    end

    it "should raise error if it receives false directly" do
      lambda { @target.should_not false }.should raise_error(Micronaut::Expectations::InvalidMatcherError)
    end

    it "should raise error if it receives false (evaluated)" do
      lambda { @target.should_not eql?("foo") }.should raise_error(Micronaut::Expectations::InvalidMatcherError)
    end

    it "should raise error if it receives true" do
      lambda { @target.should_not true }.should raise_error(Micronaut::Expectations::InvalidMatcherError)
    end

  end

end