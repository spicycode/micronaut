require File.expand_path(File.dirname(__FILE__) + "/../../../example_helper")

describe Micronaut::Formatters::ProgressFormatter do
  
  before do
    @output = StringIO.new
    @formatter = Micronaut::Formatters::ProgressFormatter.new
    @formatter.stubs(:color_enabled?).returns(false)
    @formatter.stubs(:output).returns(@output)
    @original_profile_setting = Micronaut.configuration.profile_examples
  end

  it "should produce line break on start dump" do
    @formatter.start_dump
    @output.string.should eql("\n")
  end

  it "should produce standard summary without pending when pending has a 0 count" do
    @formatter.dump_summary(3, 2, 1, 0)
    @output.string.should =~ /\nFinished in 3 seconds\n2 examples, 1 failures\n/i
  end
  
  it "should produce standard summary" do
    behaviour = Micronaut::Behaviour.describe("behaviour") do
      it('example') {}
    end
    remove_last_describe_from_world
    example = behaviour.examples.first
    @formatter.example_pending(example, "message")
    @output.rewind
    @formatter.dump_summary(3, 2, 1, 1)
    @output.string.should =~ /\nFinished in 3 seconds\n2 examples, 1 failures, 1 pending\n/i
  end
  
  describe "when color is enabled" do
    
    before do
      @formatter.stubs(:color_enabled?).returns(true)
    end

    it "should push green dot for passing spec" do
      @formatter.color_enabled?.should == true
      @formatter.example_passed("spec")
      @output.string.should == "\e[32m.\e[0m"
    end

    it "should push red F for failure spec" do
      @formatter.example_failed("spec", Micronaut::Expectations::ExpectationNotMetError.new)
      @output.string.should eql("\e[31mF\e[0m")
    end

    it "should push magenta F for error spec" do
      @formatter.example_failed("spec", RuntimeError.new)
      @output.string.should eql("\e[35mF\e[0m")
    end
    
  end
  
  it "should push nothing on start" do
    @formatter.start(4)
    @output.string.should eql("")
  end

  it "should ensure two ':' in the first backtrace" do
    backtrace = ["/tmp/x.rb:1", "/tmp/x.rb:2", "/tmp/x.rb:3"]
    @formatter.format_backtrace(backtrace).should eql(<<-EOE.rstrip)
/tmp/x.rb:1
EOE

    backtrace = ["/tmp/x.rb:1: message", "/tmp/x.rb:2", "/tmp/x.rb:3"]
    @formatter.format_backtrace(backtrace).should eql(<<-EOE.rstrip)
/tmp/x.rb:1: message
 EOE
  end
  
end