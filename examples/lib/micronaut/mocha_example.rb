require File.expand_path(File.dirname(__FILE__) + "/../../example_helper")

describe "Mocha Regression involving double reporting of errors" do

  it "should not double report mocha errors" do
    # The below example should have one error, not two
    # I'm also not sure how to test this regression without having the failure counting by 
    # the running Micronaut instance
    isolate_behaviour do
      desc = Micronaut::Behaviour.describe("my favorite pony") do
        foo = "string"
        foo.expects(:something)
      end
      formatter = stub_everything
      desc.run(formatter)
    end
  end

end
