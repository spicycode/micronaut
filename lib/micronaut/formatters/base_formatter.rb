module Micronaut
  module Formatters

    class BaseFormatter
      attr_accessor :behaviour, :total_example_failed, :total_example_pending
      attr_reader :example_count, :duration
      
      def initialize
        @total_example_failed, @total_example_pending, @example_count = 0, 0, 0
        @behaviour = nil
      end
      
      def configuration
        Micronaut.configuration
      end
      
      def output
        Micronaut.configuration.output
      end
      
      def profile_examples?
        Micronaut.configuration.profile_examples
      end
      
      def color_enabled?
        configuration.color_enabled?
      end
      
      def example_profiling_info
        @example_profiling_info ||= []
      end
      
      def pending_examples
        @pending_examples ||= []
      end
      
      def failed_examples
        @failed_examples ||= []
      end

      # This method is invoked before any examples are run, right after
      # they have all been collected. This can be useful for special
      # formatters that need to provide progress on feedback (graphical ones)
      #
      # This method will only be invoked once, and the next one to be invoked
      # is #add_behaviour
      def start(example_count)
        @example_count = example_count
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
      def start_dump(duration)
        @duration = duration
      end

      # Dumps detailed information about each example failure.
      def dump_failures
      end

      # This method is invoked after the dumping of examples and failures.
      def dump_summary
      end

      # This gets invoked after the summary if option is set to do so.
      def dump_pending
      end

      # This method is invoked at the very end. Allows the formatter to clean up, like closing open streams.
      def close
      end
      
      def format_backtrace(backtrace, example)
        return "" if backtrace.nil?
        cleansed = backtrace.map { |line| backtrace_line(line) }.compact
        original_file = example.behaviour.metadata[:file_path].split(':').first.strip
        # cleansed = cleansed.select do |line|
        #   line.split(':').first.downcase == original_file.downcase
        # end
        # we really just want it to remove the last line if there are more than 1 lines, as it is always
        # junk
        cleansed.empty? ? backtrace : cleansed
      end
      
      protected

      def backtrace_line(line)
        return nil if configuration.cleaned_from_backtrace?(line)
        line.sub!(/\A([^:]+:\d+)$/, '\\1')
        return nil if line == '-e:1'
        line
      end
      
      def read_failed_line(exception, example)
        original_file = example.options[:caller].split(':').first.strip
        matching_line = exception.backtrace.find do |line|
          line.split(':').first.downcase == original_file.downcase
        end
        return "Unable to find matching line from backtrace" if matching_line.nil?
        
        file_path, line_number = matching_line.split(':')
        open(file_path, 'r') { |f| f.readlines[line_number.to_i - 1] }
      end
      
    end
    
  end
end