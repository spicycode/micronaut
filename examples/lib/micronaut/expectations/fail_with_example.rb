require File.expand_path(File.dirname(__FILE__) + "/../../../example_helper")

describe Micronaut::Expectations do

  describe "#fail_with" do
  
    it "should handle just a message" do
      lambda { Micronaut::Expectations.fail_with "the message" }.should fail_with("the message")
    end
  
    it "should handle an Array" do
      lambda { Micronaut::Expectations.fail_with ["the message","expected","actual"] }.should fail_with("the message")
    end

  end

end