lib_path = File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'micronaut'
gem :mocha
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
  Micronaut.world.behaviours.pop
end

class DummyFormatter <  Micronaut::Formatters::BaseTextFormatter; end

def dummy_reporter
  DummyFormatter.new({}, StringIO.new)
end

Micronaut.configure do |config|
  config.mock_with :mocha
  config.color_enabled = true
  config.formatter = :progress
  config.profile_examples = true
  config.add_filter :options => { :focused => true }
  config.autorun!
end