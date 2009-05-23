lib_path = File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'micronaut'
require 'rubygems'

def with_ruby(version)
  yield if RUBY_PLATFORM =~ Regexp.compile("^#{version}")
end

with_ruby("1.8") { gem :mocha }

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

def isolate_behaviour
  if block_given?
    yield
    Micronaut.world.behaviours.pop
  end
end

def use_formatter(new_formatter)
  original_formatter = Micronaut.configuration.formatter
  Micronaut.configuration.instance_variable_set(:@formatter, new_formatter)
  yield
ensure
  Micronaut.configuration.instance_variable_set(:@formatter, original_formatter)
end

def not_in_editor?
  !(ENV.has_key?('TM_MODE') || ENV.has_key?('EMACS') || ENV.has_key?('VIM'))
end

Micronaut.configure do |c|
  c.mock_with :mocha
  c.color_enabled = not_in_editor?
  c.filter_run :focused => true
end
