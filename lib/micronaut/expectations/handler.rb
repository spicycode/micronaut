module Micronaut
  module Expectations
    

    # class ExpectationMatcherHandler        
    # 
    #      def self.handle_matcher(actual, matcher, &block)
    #        ::Micronaut::Matchers.last_should = "should"
    #        return Micronaut::Matchers::PositiveOperatorMatcher.new(actual) if matcher.nil?
    # 
    #        unless matcher.respond_to?(:matches?)
    #          raise InvalidMatcherError, "Expected a matcher, got #{matcher.inspect}."
    #        end
    # 
    #        match = matcher.matches?(actual, &block)
    #        ::Micronaut::Matchers.last_matcher = matcher
    #        Micronaut::Expectations.fail_with(matcher.failure_message) unless match
    #        match
    #      end
    # 
    #    end

    # class NegativeExpectationMatcherHandler
    # 
    #      def self.handle_matcher(actual, matcher, &block)
    #        ::Micronaut::Matchers.last_should = "should not"
    #        return Micronaut::Matchers::NegativeOperatorMatcher.new(actual) if matcher.nil?
    # 
    #        unless matcher.respond_to?(:matches?)
    #          raise InvalidMatcherError, "Expected a matcher, got #{matcher.inspect}."
    #        end
    # 
    #        unless matcher.respond_to?(:negative_failure_message)
    #          Micronaut::Expectations.fail_with(
    #          <<-EOF
    #          Matcher does not support should_not.
    #          See Micronaut::Matchers for more information
    #          about matchers.
    #          EOF
    #          )
    #        end
    #        match = matcher.matches?(actual, &block)
    #        ::Micronaut::Matchers.last_matcher = matcher
    #        Micronaut::Expectations.fail_with(matcher.negative_failure_message) if match
    #        match
    #      end
   
    # end

  end
end