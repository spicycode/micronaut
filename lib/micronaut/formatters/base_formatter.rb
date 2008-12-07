module Micronaut
  module Formatters
    # Baseclass for formatters that implements all required methods as no-ops. 
    class BaseFormatter
      attr_accessor :behaviour, :options, :output, :total_example_failed, :total_example_pending
      
      def initialize(options, output_to)
        @options, @output = options, output_to
        @total_example_failed, @total_example_pending = 0, 0
      end

      # This method is invoked before any examples are run, right after
      # they have all been collected. This can be useful for special
      # formatters that need to provide progress on feedback (graphical ones)
      #
      # This method will only be invoked once, and the next one to be invoked
      # is #add_behaviour
      def start(example_count)
      end

      # This method is invoked at the beginning of the execution of each behaviour.
      # +behaviour+ is the behaviour.
      #
      # The next method to be invoked after this is #example_failed or #example_finished
      def add_behaviour(behaviour)
        @behaviour = behaviour
      end

      # This method is invoked when an +example+ starts.
      def example_started(example)
      end

      # This method is invoked when an +example+ passes.
      def example_passed(example)
      end

      # This method is invoked when an +example+ fails, i.e. an exception occurred
      # inside it (such as a failed should or other exception). +counter+ is the 
      # sequence number of the failure (starting at 1) and +failure+ is the associated 
      # exception.
      def example_failed(example, exception)
        @total_example_failed += 1
      end

      # This method is invoked when an example is not yet implemented (i.e. has not
      # been provided a block), or when an ExamplePendingError is raised.
      # +message+ is the message from the ExamplePendingError, if it exists, or the
      # default value of "Not Yet Implemented"
      # +pending_caller+ is the file and line number of the spec which
      # has called the pending method
      def example_pending(example, message)
      end

      # This method is invoked after all of the examples have executed. The next method
      # to be invoked after this one is #dump_failure (once for each failed example),
      def start_dump
      end

      # Dumps detailed information about each example failure.
      def dump_failures
      end

      # This method is invoked after the dumping of examples and failures.
      def dump_summary(duration, example_count, failure_count, pending_count)
      end

      # This gets invoked after the summary if option is set to do so.
      def dump_pending
      end

      # This method is invoked at the very end. Allows the formatter to clean up, like closing open streams.
      def close
      end
    end
    
  end
end