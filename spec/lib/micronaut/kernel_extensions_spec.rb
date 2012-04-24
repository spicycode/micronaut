require 'spec_helper'

describe Micronaut::KernelExtensions do
  
  it "should be included in Object" do
    Object.included_modules.should include(Micronaut::KernelExtensions)
  end
  
  it "should add a describe method to Object" do
    Object.should respond_to(:describe)
  end

end
