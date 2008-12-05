lib_path = File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'micronaut'
require File.expand_path(File.dirname(__FILE__) + "/resources/example_classes")

module Micronaut  
  module Matchers
    def fail
      raise_error(::Micronaut::Expectations::ExpectationNotMetError)
    end

    def fail_with(message)
      raise_error(::Micronaut::Expectations::ExpectationNotMetError, message)
    end
  end
end

def remove_last_describe_from_world
  Micronaut::World.behaviour_groups.pop
end

class DummyFormatter <  Micronaut::Formatters::BaseTextFormatter; end

def dummy_reporter
  DummyFormatter.new({}, StringIO.new)
end

Micronaut.configure do |config|
  
  config.mock_with :mocha
  
  config.before(:each, :pending => true) do 
    raise "the roof"
  end
  
  config.after(:each, :focused => true) do
    puts 'was the focus worth it?'
  end
  
end

Micronaut::Runner.autorun
