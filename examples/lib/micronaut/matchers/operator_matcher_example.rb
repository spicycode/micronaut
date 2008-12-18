require File.expand_path(File.dirname(__FILE__) + "/../../../example_helper")

describe "Operator Matchers" do 
  
  describe "should ==" do
  
    it "should delegate message to target" do
      subject = "apple"
      subject.expects(:==).with("apple").returns(true)
      subject.should == "apple"
    end
  
    it "should return true on success" do
      subject = "apple"
      (subject.should == "apple").should be_true
    end
  
    it "should fail when target.==(actual) returns false" do
      subject = "apple"
      Micronaut::Expectations.expects(:fail_with).with(%[expected: "orange",\n     got: "apple" (using ==)], "orange", "apple")
      subject.should == "orange"
    end
  
  end

  describe "should_not ==" do
  
    it "should delegate message to target" do
      subject = "orange"
      subject.expects(:==).with("apple").returns(false)
      subject.should_not == "apple"
    end
  
    it "should return true on success" do
      subject = "apple"
      (subject.should_not == "orange").should be_true
    end

    it "should fail when target.==(actual) returns false" do
      subject = "apple"
      Micronaut::Expectations.expects(:fail_with).with(%[expected not: == "apple",\n         got:    "apple"], "apple", "apple")
      subject.should_not == "apple"
    end
  
  end

  describe "should ===" do
  
    it "should delegate message to target" do
      subject = "apple"
      subject.expects(:===).with("apple").returns(true)
      subject.should === "apple"
    end
  
    it "should fail when target.===(actual) returns false" do
      subject = "apple"
      subject.expects(:===).with("orange").returns(false)
      Micronaut::Expectations.expects(:fail_with).with(%[expected: "orange",\n     got: "apple" (using ===)], "orange", "apple")
      subject.should === "orange"
    end
  
  end

  describe "should_not ===" do
  
    it "should delegate message to target" do
      subject = "orange"
      subject.expects(:===).with("apple").returns(false)
      subject.should_not === "apple"
    end
  
    it "should fail when target.===(actual) returns false" do
      subject = "apple"
      subject.expects(:===).with("apple").returns(true)
      Micronaut::Expectations.expects(:fail_with).with(%[expected not: === "apple",\n         got:     "apple"], "apple", "apple")
      subject.should_not === "apple"
    end

  end

  describe "should =~" do
  
    it "should delegate message to target" do
      subject = "foo"
      subject.expects(:=~).with(/oo/).returns(true)
      subject.should =~ /oo/
    end
  
    it "should fail when target.=~(actual) returns false" do
      subject = "fu"
      subject.expects(:=~).with(/oo/).returns(false)
      Micronaut::Expectations.expects(:fail_with).with(%[expected: /oo/,\n     got: "fu" (using =~)], /oo/, "fu")
      subject.should =~ /oo/
    end

  end

  describe "should_not =~" do
  
    it "should delegate message to target" do
      subject = "fu"
      subject.expects(:=~).with(/oo/).returns(false)
      subject.should_not =~ /oo/
    end
  
    it "should fail when target.=~(actual) returns false" do
      subject = "foo"
      subject.expects(:=~).with(/oo/).returns(true)
      Micronaut::Expectations.expects(:fail_with).with(%[expected not: =~ /oo/,\n         got:    "foo"], /oo/, "foo")
      subject.should_not =~ /oo/
    end

  end

  describe "should >" do
  
    it "should pass if > passes" do
      4.should > 3
    end

    it "should fail if > fails" do
      Micronaut::Expectations.expects(:fail_with).with(%[expected: > 5,\n     got:   4], 5, 4)
      4.should > 5
    end

  end

  describe "should >=" do
  
    it "should pass if >= passes" do
      4.should > 3
      4.should >= 4
    end

    it "should fail if > fails" do
      Micronaut::Expectations.expects(:fail_with).with(%[expected: >= 5,\n     got:    4], 5, 4)
      4.should >= 5
    end

  end

  describe "should <" do
  
    it "should pass if < passes" do
      4.should < 5
    end

    it "should fail if > fails" do
      Micronaut::Expectations.expects(:fail_with).with(%[expected: < 3,\n     got:   4], 3, 4)
      4.should < 3
    end

  end

  describe "should <=" do
  
    it "should pass if <= passes" do
      4.should <= 5
      4.should <= 4
    end

    it "should fail if > fails" do
      Micronaut::Expectations.expects(:fail_with).with(%[expected: <= 3,\n     got:    4], 3, 4)
      4.should <= 3
    end

  end

  describe Micronaut::Matchers::PositiveOperatorMatcher do

    it "should work when the target has implemented #send" do
      o = Object.new
      def o.send(*args); raise "DOH! Library developers shouldn't use #send!" end
      lambda {
        o.should == o
      }.should_not raise_error
    end

  end

  describe Micronaut::Matchers::NegativeOperatorMatcher do

    it "should work when the target has implemented #send" do
      o = Object.new
      def o.send(*args); raise "DOH! Library developers shouldn't use #send!" end
      lambda {
        o.should_not == :foo
      }.should_not raise_error
    end

  end

end