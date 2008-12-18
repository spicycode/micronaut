require File.expand_path(File.dirname(__FILE__) + "/../../../example_helper")

describe Micronaut::Matchers, "provides the following matchers to examples" do

  it "be_true" do
    be_true.should be_an_instance_of(Micronaut::Matchers::Be)
  end

  it "be_false" do
    be_false.should be_an_instance_of(Micronaut::Matchers::Be)
  end

  it "be_nil" do
    be_nil.should be_an_instance_of(Micronaut::Matchers::Be)
  end

  it "be_arbitrary_predicate" do
    be_arbitrary_predicate.should be_an_instance_of(Micronaut::Matchers::Be)
  end

  it "change" do
    change("target", :message).should be_an_instance_of(Micronaut::Matchers::Change)
  end

  it "have" do
    have(0).should be_an_instance_of(Micronaut::Matchers::Have)
  end

  it "have_exactly" do
    have_exactly(0).should be_an_instance_of(Micronaut::Matchers::Have)
  end

  it "have_at_least" do
    have_at_least(0).should be_an_instance_of(Micronaut::Matchers::Have)
  end

  it "have_at_most" do
    have_at_most(0).should be_an_instance_of(Micronaut::Matchers::Have)
  end

  it "include" do
    include(:value).should be_an_instance_of(Micronaut::Matchers::Include)
  end

  it "raise_error" do
    raise_error.should be_an_instance_of(Micronaut::Matchers::RaiseError)
    raise_error(NoMethodError).should be_an_instance_of(Micronaut::Matchers::RaiseError)
    raise_error(NoMethodError, "message").should be_an_instance_of(Micronaut::Matchers::RaiseError)
  end

  it "satisfy" do
    satisfy{}.should be_an_instance_of(Micronaut::Matchers::Satisfy)
  end

  it "throw_symbol" do
    throw_symbol.should be_an_instance_of(Micronaut::Matchers::ThrowSymbol)
    throw_symbol(:sym).should be_an_instance_of(Micronaut::Matchers::ThrowSymbol)
  end

  it "respond_to" do
    respond_to(:sym).should be_an_instance_of(Micronaut::Matchers::RespondTo)
  end
  
  describe "#method_missing" do

    it "should convert be_xyz to Be(:be_xyz)" do
      Micronaut::Matchers::Be.expects(:new).with(:be_whatever)
      be_whatever
    end

    it "should convert have_xyz to Has(:have_xyz)" do
      self.expects(:has).with(:have_whatever)
      have_whatever
    end

  end

end