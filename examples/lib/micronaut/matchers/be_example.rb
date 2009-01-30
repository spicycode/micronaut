require File.expand_path(File.dirname(__FILE__) + "/../../../example_helper")

describe Micronaut::Matchers do

  describe "should be_predicate" do  

    it "should pass when actual returns true for :predicate?" do
      actual = stub("actual", :happy? => true)
      actual.should be_happy
    end

    it "should pass when actual returns true for :predicates? (present tense)" do
      actual = stub("actual", :exists? => true, :exist? => true)
      actual.should be_exist
    end

    it "should fail when actual returns false for :predicate?" do
      actual = stub("actual", :happy? => false)
      lambda do
        actual.should be_happy
      end.should fail_with("expected happy? to return true, got false")
    end

    it "should fail when actual does not respond to :predicate?" do
      lambda do
        Object.new.should be_happy
      end.should raise_error(NameError, /happy\?/)
    end

    it "should fail on error other than NameError" do
      actual = stub("actual")
      actual.expects(:foo?).raises("aaaah")
      lambda do
        actual.should be_foo
      end.should raise_error(/aaaah/)
    end

    it "should fail on error other than NameError (with the present tense predicate)" do
      actual = Object.new
      actual.expects(:foos?).raises("aaaah")
      lambda do
        actual.should be_foo
      end.should raise_error(/aaaah/)
    end

  end

  describe "should_not be_predicate" do

    it "should pass when actual returns false for :sym?" do
      actual = stub("actual", :happy? => false)
      actual.should_not be_happy
    end

    it "should fail when actual returns true for :sym?" do
      actual = stub("actual", :happy? => true)
      lambda do
        actual.should_not be_happy
      end.should fail_with("expected happy? to return false, got true")
    end

    it "should fail when actual does not respond to :sym?" do
      lambda do
        Object.new.should_not be_happy
      end.should raise_error(NameError)
    end

  end

  describe "should be_predicate(*args)" do

    it "should pass when actual returns true for :predicate?(*args)" do
      actual = mock("actual")
      actual.expects(:older_than?).with(3).returns(true)
      actual.should be_older_than(3)
    end

    it "should fail when actual returns false for :predicate?(*args)" do
      actual = mock("actual")
      actual.expects(:older_than?).with(3).returns(false)
      lambda do
        actual.should be_older_than(3)
      end.should fail_with("expected older_than?(3) to return true, got false")
    end

    it "should fail when actual does not respond to :predicate?" do
      lambda do
        Object.new.should be_older_than(3)
      end.should raise_error(NameError)
    end

  end

  describe "should_not be_predicate(*args)" do

    it "should pass when actual returns false for :predicate?(*args)" do
      actual = mock("actual")
      actual.expects(:older_than?).with(3).returns(false)
      actual.should_not be_older_than(3)
    end

    it "should fail when actual returns true for :predicate?(*args)" do
      actual = mock("actual")
      actual.expects(:older_than?).with(3).returns(true)
      lambda do
        actual.should_not be_older_than(3)
      end.should fail_with("expected older_than?(3) to return false, got true")
    end

    it "should fail when actual does not respond to :predicate?" do
      lambda do
        Object.new.should_not be_older_than(3)
      end.should raise_error(NameError)
    end

  end

  describe "should be_true" do

    it "should pass when actual equal(true)" do
      true.should be_true
    end

    it "should fail when actual equal(false)" do
      lambda do
        false.should be_true
      end.should fail_with("expected true, got false")
    end

  end

  describe "should be_false" do

    it "should pass when actual equal(false)" do
      false.should be_false
    end

    it "should fail when actual equal(true)" do
      lambda do
        true.should be_false
      end.should fail_with("expected false, got true")
    end

  end

  describe "should be_nil" do

    it "should pass when actual is nil" do
      nil.should be_nil
    end

    it "should fail when actual is not nil" do
      lambda do
        :not_nil.should be_nil
      end.should fail_with("expected nil? to return true, got false")
    end

  end

  describe "should_not be_nil" do

    it "should pass when actual is not nil" do
      :not_nil.should_not be_nil
    end

    it "should fail when actual is nil" do
      lambda do
        nil.should_not be_nil
      end.should fail_with("expected nil? to return false, got true")
    end

  end

  describe "should be <" do

    it "should pass when < operator returns true" do
      3.should be < 4
    end

    it "should fail when < operator returns false" do
      lambda { 3.should be < 3 }.should fail_with("expected < 3, got 3")
    end

  end

  describe "should be <=" do

    it "should pass when <= operator returns true" do
      3.should be <= 4
      4.should be <= 4
    end

    it "should fail when <= operator returns false" do
      lambda { 3.should be <= 2 }.should fail_with("expected <= 2, got 3")
    end

  end

  describe "should be >=" do

    it "should pass when >= operator returns true" do
      4.should be >= 4
      5.should be >= 4
    end

    it "should fail when >= operator returns false" do
      lambda { 3.should be >= 4 }.should fail_with("expected >= 4, got 3")
    end

  end

  describe "should be >" do

    it "should pass when > operator returns true" do
      5.should be > 4
    end

    it "should fail when > operator returns false" do
      lambda { 3.should be > 4 }.should fail_with("expected > 4, got 3")
    end

  end

  describe "should be ==" do

    it "should pass when == operator returns true" do
      5.should be == 5
    end

    it "should fail when == operator returns false" do
      lambda { 3.should be == 4 }.should fail_with("expected == 4, got 3")
    end

  end

  describe "should be ===" do

    it "should pass when === operator returns true" do
      Hash.should be === Hash.new
    end

    it "should fail when === operator returns false" do
      lambda { Hash.should be === "not a hash" }.should fail_with(%[expected === not a hash, got Hash])
    end

  end

  describe "should_not with operators" do

    it "should coach user to stop using operators with should_not" do
      lambda do
        5.should_not be < 6
      end.should raise_error(/not only FAILED,\nit reads really poorly./m)
    end

  end

  describe "should be" do

    it "should pass if actual is true or a set value" do
      true.should be
      1.should be
    end

    it "should fail if actual is false" do
      lambda {false.should be}.should fail_with("expected true, got false")
    end

    it "should fail if actual is nil" do
      lambda {nil.should be}.should fail_with("expected true, got nil")
    end

  end

  describe "should be(value)" do

    it "should pass if actual.equal?(value)" do
      5.should be(5)
    end

    it "should fail if !actual.equal?(value)" do
      lambda { 5.should be(6) }.should fail_with("expected 6, got 5")
    end

  end

  describe "'should be' with operator" do

    it "should include 'be' in the description" do
      (be > 6).description.should =~ /be > 6/
      (be >= 6).description.should =~ /be >= 6/
      (be <= 6).description.should =~ /be <= 6/
      (be < 6).description.should =~ /be < 6/
    end

  end

end