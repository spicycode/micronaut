lib_path = File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'micronaut'


module Micronaut  
  module Matchers
    def fail
      raise_error(::Micronaut::Exceptions::ExpectationNotMetError)
    end

    def fail_with(message)
      raise_error(::Micronaut::Exceptions::ExpectationNotMetError, message)
    end
  end
end

Micronaut::ExampleRunner.autorun