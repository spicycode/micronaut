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
  
  module ExampleExpectations

    class ArbitraryMatcher
      def initialize(*args, &block)
        if args.last.is_a? Hash
          @expected = args.last[:expected]
        end
        if block_given?
          @expected = block.call
        end
        @block = block
      end

      def matches?(target)
        @target = target
        return @expected == target
      end

      def with(new_value)
        @expected = new_value
        self
      end

      def failure_message
        "expected #{@expected}, got #{@target}"
      end

      def negative_failure_message
        "expected not #{@expected}, got #{@target}"
      end
    end

    class PositiveOnlyMatcher < ArbitraryMatcher
      undef negative_failure_message rescue nil
    end

    def arbitrary_matcher(*args, &block)
      ArbitraryMatcher.new(*args, &block)
    end

    def positive_only_matcher(*args, &block)
      PositiveOnlyMatcher.new(*args, &block)
    end

  end

  describe "should and should not matcher handling" do
    include ExampleExpectations

    it "should handle submitted args" do
      5.should arbitrary_matcher(:expected => 5)
      5.should arbitrary_matcher(:expected => "wrong").with(5)
      lambda { 5.should arbitrary_matcher(:expected => 4) }.should fail_with("expected 4, got 5")
      lambda { 5.should arbitrary_matcher(:expected => 5).with(4) }.should fail_with("expected 4, got 5")
      5.should_not arbitrary_matcher(:expected => 4)
      5.should_not arbitrary_matcher(:expected => 5).with(4)
      lambda { 5.should_not arbitrary_matcher(:expected => 5) }.should fail_with("expected not 5, got 5")
      lambda { 5.should_not arbitrary_matcher(:expected => 4).with(5) }.should fail_with("expected not 5, got 5")
    end

    it "should handle the submitted block" do
      5.should arbitrary_matcher { 5 }
      5.should arbitrary_matcher(:expected => 4) { 5 }
      5.should arbitrary_matcher(:expected => 4).with(5) { 3 }
    end

    it "should explain when matcher does not support should_not" do
      lambda {
        5.should_not positive_only_matcher(:expected => 5)
      }.should fail_with(/Matcher does not support should_not.\n/)
    end

  end

end