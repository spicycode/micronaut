module Micronaut
  module Formatters

    class DocumentationFormatter < BaseTextFormatter

      attr_reader :previous_nested_behaviours

      def initialize
        super
        @previous_nested_behaviours = []
      end

      def add_behaviour(behaviour)
        super

        described_behaviour_chain.each_with_index do |nested_behaviour, i|
          unless nested_behaviour == previous_nested_behaviours[i]
            at_root_level = (i == 0)
            desc_or_name = at_root_level ? nested_behaviour.name : nested_behaviour.description
            output.puts if at_root_level
            output.puts "#{'  ' * i}#{desc_or_name}"
          end
        end
        
        @previous_nested_behaviours = described_behaviour_chain
      end

      def example_failed(example, exception)
        super
        expectation_not_met = exception.is_a?(Micronaut::Expectations::ExpectationNotMetError)
        
        message = if expectation_not_met
          "#{current_indentation}#{example.description} (FAILED)"
        else
          "#{current_indentation}#{example.description} (ERROR)"
        end

        output.puts(expectation_not_met ? red(message) : magenta(message))
        output.flush
      end

      def example_passed(example)
        super
        output.puts green("#{current_indentation}#{example.description}")
        output.flush
      end

      def example_pending(example, message)
        super
        output.puts yellow("#{current_indentation}#{example.description} (PENDING: #{message})")
        output.flush
      end

      def current_indentation
        '  ' * previous_nested_behaviours.length
      end

      def described_behaviour_chain
        behaviour.ancestors
      end

    end
    
  end
end