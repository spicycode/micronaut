require 'micronaut/matchers/generated_descriptions'
require 'micronaut/matchers/simple_matcher'
require 'micronaut/matchers/be'
require 'micronaut/matchers/be_close'
require 'micronaut/matchers/change'
require 'micronaut/matchers/eql'
require 'micronaut/matchers/equal'
require 'micronaut/matchers/has'
require 'micronaut/matchers/have'
require 'micronaut/matchers/include'
require 'micronaut/matchers/match'
require 'micronaut/matchers/raise_error'
require 'micronaut/matchers/respond_to'
require 'micronaut/matchers/satisfy'
require 'micronaut/matchers/throw_symbol'
require 'micronaut/matchers/operator_matcher'

module Micronaut

  # We ship (courtesy of RSpec and Micronaut) with a number of useful Expression Matchers. An Expression Matcher
  # is any object that responds to the following methods:
  #
  #   matches?(actual)
  #   failure_message
  #   negative_failure_message #optional
  #   description #optional
  #
  # See Micronaut::Expectations to learn how to use these as Expectation Matchers.
  # See Micronaut::Mocks to learn how to use them as Mock Argument Constraints.
  #
  # == Predicates
  #
  # In addition to those Expression Matchers that are defined explicitly, we will
  # create custom Matchers on the fly for any arbitrary predicate, giving your specs
  # a much more natural language feel. 
  #
  # A Ruby predicate is a method that ends with a "?" and returns true or false.
  # Common examples are +empty?+, +nil?+, and +instance_of?+.
  #
  # All you need to do is write +should be_+ followed by the predicate without
  # the question mark, and we will figure it out from there. For example:
  #
  #   [].should be_empty => [].empty? #passes
  #   [].should_not be_empty => [].empty? #fails
  #
  # In addtion to prefixing the predicate matchers with "be_", you can also use "be_a_"
  # and "be_an_", making your specs read much more naturally:
  #
  #   "a string".should be_an_instance_of(String) =>"a string".instance_of?(String) #passes
  #
  #   3.should be_a_kind_of(Fixnum) => 3.kind_of?(Numeric) #passes
  #   3.should be_a_kind_of(Numeric) => 3.kind_of?(Numeric) #passes
  #   3.should be_an_instance_of(Fixnum) => 3.instance_of?(Fixnum) #passes
  #   3.should_not be_instance_of(Numeric) => 3.instance_of?(Numeric) #fails
  #
  # We will also create custom matchers for predicates like +has_key?+. To
  # use this feature, just state that the object should have_key(:key) and we will
  # call has_key?(:key) on the target. For example:
  #
  #   {:a => "A"}.should have_key(:a) => {:a => "A"}.has_key?(:a) #passes
  #   {:a => "A"}.should have_key(:b) => {:a => "A"}.has_key?(:b) #fails
  #
  # You can use this feature to invoke any predicate that begins with "has_", whether it is
  # part of the Ruby libraries (like +Hash#has_key?+) or a method you wrote on your own class.
  #
  # == Custom Expectation Matchers
  #
  # When you find that none of the stock Expectation Matchers provide a natural
  # feeling expectation, you can very easily write your own.
  #
  # For example, imagine that you are writing a game in which players can
  # be in various zones on a virtual board. To specify that bob should
  # be in zone 4, you could say:
  #
  #   bob.current_zone.should eql(Zone.new("4"))
  #
  # But you might find it more expressive to say:
  #
  #   bob.should be_in_zone("4")
  #
  # and/or
  #
  #   bob.should_not be_in_zone("3")
  #
  # To do this, you would need to write a class like this:
  #
  #   class BeInZone
  #     def initialize(expected)
  #       @expected = expected
  #     end
  #     def matches?(target)
  #       @target = target
  #       @target.current_zone.eql?(Zone.new(@expected))
  #     end
  #     def failure_message
  #       "expected #{@target.inspect} to be in Zone #{@expected}"
  #     end
  #     def negative_failure_message
  #       "expected #{@target.inspect} not to be in Zone #{@expected}"
  #     end
  #   end
  #
  # ... and a method like this:
  #
  #   def be_in_zone(expected)
  #     BeInZone.new(expected)
  #   end
  #
  # And then expose the method to your specs. This is normally done
  # by including the method and the class in a module, which is then
  # included in your spec:
  #
  #   module CustomGameMatchers
  #     class BeInZone
  #       ...
  #     end
  #
  #     def be_in_zone(expected)
  #       ...
  #     end
  #   end
  #
  #   describe "Player behaviour" do
  #     include CustomGameMatchers
  #     ...
  #   end

  module Matchers
    
    class MatcherError < StandardError; end
    
    private
    def method_missing(sym, *args, &block) # :nodoc:
      return Matchers::Be.new(sym, *args) if sym.to_s =~ /^be_/
      return has(sym, *args) if sym.to_s =~ /^have_/
      super
    end
      
  end
  
end
