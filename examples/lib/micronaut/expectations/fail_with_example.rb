require File.expand_path(File.dirname(__FILE__) + "/../../../example_helper")

describe Micronaut::Expectations, "#fail_with with no diff" do
  before do
    @old_differ = Micronaut::Expectations.differ
    Micronaut::Expectations.differ = nil
  end
  
  it "should handle just a message" do
    lambda {
      Micronaut::Expectations.fail_with "the message"
    }.should fail_with("the message")
  end
  
  it "should handle an Array" do
    lambda {
      Micronaut::Expectations.fail_with ["the message","expected","actual"]
    }.should fail_with("the message")
  end

  after(:each) do
    Micronaut::Expectations.differ = @old_differ
  end
end

describe Micronaut::Expectations, "#fail_with with diff" do
  before do
    @old_differ = Micronaut::Expectations.differ
    @differ = mock("differ")
    Micronaut::Expectations.differ = @differ
  end
  
  it "should not call differ if no expected/actual" do
    lambda {
      Micronaut::Expectations.fail_with "the message"
    }.should fail_with("the message")
  end
  
  it "should call differ if expected/actual are presented separately" do
    @differ.expects(:diff_as_string).returns("diff")
    lambda {
      Micronaut::Expectations.fail_with "the message", "expected", "actual"
    }.should fail_with("the message\nDiff:diff")
  end
  
  it "should call differ if expected/actual are not strings" do
    @differ.expects(:diff_as_object).returns("diff")
    lambda {
      Micronaut::Expectations.fail_with "the message", :expected, :actual
    }.should fail_with("the message\nDiff:diff")
  end
  
  it "should not call differ if expected or actual are procs" do
    @differ.expects(:diff_as_string).never
    @differ.expects(:diff_as_object).never
    lambda {
      Micronaut::Expectations.fail_with "the message", lambda {}, lambda {}
    }.should fail_with("the message")
  end
  
  it "should call differ if expected/actual are presented in an Array with message" do
    @differ.expects(:diff_as_string).with("actual","expected").returns("diff")
    lambda {
      Micronaut::Expectations.fail_with(["the message", "expected", "actual"])
    }.should fail_with(/the message\nDiff:diff/)
  end
  
  after(:each) do
    Micronaut::Expectations.differ = @old_differ
  end
end
