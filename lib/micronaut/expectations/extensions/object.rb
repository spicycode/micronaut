module Micronaut
  module Expectations
    class InvalidMatcherError < ArgumentError; end        
    
    module ObjectExpectations
      # :call-seq:
      #   should(matcher)
      #   should == expected
      #   should === expected
      #   should =~ expected
      #
      #   receiver.should(matcher)
      #     => Passes if matcher.matches?(receiver)
      #
      #   receiver.should == expected #any value
      #     => Passes if (receiver == expected)
      #
      #   receiver.should === expected #any value
      #     => Passes if (receiver === expected)
      #
      #   receiver.should =~ regexp
      #     => Passes if (receiver =~ regexp)
      #
      # See Micronaut::Matchers for more information about matchers
      #
      # == Warning
      # NOTE that this does NOT support receiver.should != expected.
      # Instead, use receiver.should_not == expected
      def should(matcher=nil, &block)
        ::Micronaut::Matchers.last_should = "should"
        return ::Micronaut::Matchers::PositiveOperatorMatcher.new(self) if matcher.nil?

        unless matcher.respond_to?(:matches?)
          raise InvalidMatcherError, "Expected a matcher, got #{matcher.inspect}."
        end

        match_found = matcher.matches?(self, &block)
        ::Micronaut::Matchers.last_matcher = matcher
        
        ::Micronaut::Expectations.fail_with(matcher.failure_message) unless match_found
        match_found
      end

      # :call-seq:
      #   should_not(matcher)
      #   should_not == expected
      #   should_not === expected
      #   should_not =~ expected
      #
      #   receiver.should_not(matcher)
      #     => Passes unless matcher.matches?(receiver)
      #
      #   receiver.should_not == expected
      #     => Passes unless (receiver == expected)
      #
      #   receiver.should_not === expected
      #     => Passes unless (receiver === expected)
      #
      #   receiver.should_not =~ regexp
      #     => Passes unless (receiver =~ regexp)
      #
      # See Micronaut::Matchers for more information about matchers
      def should_not(matcher=nil, &block)
        ::Micronaut::Matchers.last_should = "should not"
        return ::Micronaut::Matchers::NegativeOperatorMatcher.new(self) if matcher.nil?

        unless matcher.respond_to?(:matches?)
          raise InvalidMatcherError, "Expected a matcher, got #{matcher.inspect}."
        end

        unless matcher.respond_to?(:negative_failure_message)
          ::Micronaut::Expectations.fail_with(
          <<-EOF
          Matcher does not support should_not.
          See Micronaut::Matchers for more information about matchers.
          EOF
          )
        end
        match_found = matcher.matches?(self, &block)
        ::Micronaut::Matchers.last_matcher = matcher
        
        ::Micronaut::Expectations.fail_with(matcher.negative_failure_message) if match_found
        match_found
      end

    end
  end
end

class Object
  include Micronaut::Expectations::ObjectExpectations
end