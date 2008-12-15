require 'micronaut/matchers'
require 'micronaut/expectations/extensions/object'
require 'micronaut/expectations/extensions/string_and_symbol'
require 'micronaut/expectations/handler'
require 'micronaut/expectations/wrap_expectation'

module Micronaut

  # Micronaut::Expectations lets you set expectations on your objects.
  #
  #   result.should == 37
  #   team.should have(11).players_on_the_field
  #
  # == How Expectations work.
  #
  # Micronaut::Expectations adds two methods to Object:
  #
  #   should(matcher=nil)
  #   should_not(matcher=nil)
  #
  # Both methods take an optional Expression Matcher (See Micronaut::Matchers).
  #
  # When +should+ receives an Expression Matcher, it calls <tt>matches?(self)</tt>. If
  # it returns +true+, the spec passes and execution continues. If it returns
  # +false+, then the spec fails with the message returned by <tt>matcher.failure_message</tt>.
  #
  # Similarly, when +should_not+ receives a matcher, it calls <tt>matches?(self)</tt>. If
  # it returns +false+, the spec passes and execution continues. If it returns
  # +true+, then the spec fails with the message returned by <tt>matcher.negative_failure_message</tt>.
  #
  # Micronaut ships with a standard set of useful matchers, and writing your own
  # matchers is quite simple. See Micronaut::Matchers for details.
  module Expectations

    class ExpectationNotMetError < ::StandardError; end
  
    def self.fail_with(message, expected=nil, target=nil) # :nodoc:
      if Array === message && message.length == 3
        message, expected, target = message[0], message[1], message[2]
      end
      Kernel::raise(Micronaut::Expectations::ExpectationNotMetError.new(message))
    end
  
  end
  
end
