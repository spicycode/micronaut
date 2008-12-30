require File.expand_path(File.dirname(__FILE__) + "/../../../example_helper")

describe Micronaut::Formatters::ProgressFormatter do
  
   before do
     @output = StringIO.new
     @formatter = Micronaut::Formatters::ProgressFormatter.new
     @formatter.start(2)
     @formatter.stubs(:color_enabled?).returns(false)
     @formatter.stubs(:output).returns(@output)
   end
   
   it "should produce line break on start dump" do
     @formatter.start_dump(3)
     @output.string.should == "\n"
   end
   
   it "should produce standard summary without pending when pending has a 0 count" do
     @formatter.start_dump(3)
     @formatter.dump_summary
     @output.string.should =~ /Finished in 3 seconds\n2 examples/i
   end
   
   it "should produce standard summary" do
     @formatter.start_dump(3)
     @formatter.example_pending(running_example, "message")
     @output.rewind
     @formatter.dump_summary
     @output.string.should =~ /Finished in 3 seconds\n2 examples/i
   end
   
   describe "when color is enabled" do
     
     before do
       @formatter.stubs(:trace?).returns(false)
       @formatter.stubs(:color_enabled?).returns(true)
     end
   
     it "should output a green dot for passing spec" do
       @formatter.example_passed("spec")
       @output.string.should == "\e[32m.\e[0m"
     end
   
     it "should push red F for failure spec" do
       @formatter.example_failed("spec", Micronaut::Expectations::ExpectationNotMetError.new)
       @output.string.should == "\e[31mF\e[0m"
     end
   
     it "should push magenta F for error spec" do
       @formatter.example_failed("spec", RuntimeError.new)
       @output.string.should == "\e[35mF\e[0m"
     end
     
   end
   
   it "should push nothing on start" do
     @formatter.start(4)
     @output.string.should == ""
   end
   
end