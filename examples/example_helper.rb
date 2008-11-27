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

def remove_last_describe_from_runner
  Micronaut::ExampleWorld.example_groups.pop
end

class DummyFormatter <  Micronaut::Formatters::BaseTextFormatter; end

def dummy_reporter
  DummyFormatter.new({}, StringIO.new)
end

Micronaut::Runner.autorun