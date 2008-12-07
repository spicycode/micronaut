module Micronaut

  module Formatters

    class BaseTextFormatter < BaseFormatter
      attr_reader :pending_examples, :failed_examples

      def initialize(options, output_to)
        super
        @pending_examples = []
        @failed_examples = []
      end

      def example_pending(example, message)
        @pending_examples << [example, message]
      end

      def example_failed(example, exception)
        super
        @failed_examples << [example, exception]
      end

      def dump_failures        
        @output.puts
        @failed_examples.each_with_index do |examples_with_exception, index|
          example, exception = examples_with_exception.first, examples_with_exception.last
          @output.puts "#{index.next}) #{example}"
          @output.puts colorise(exception.message, exception)
          @output.puts format_backtrace(exception.backtrace)
          @output.puts 
          @output.flush
        end
      end

      def colorise(s, failure)
        if failure.is_a?(Micronaut::Expectations::ExpectationNotMetError)
          red(s)
        else
          magenta(s)
        end
      end

      def dump_summary(duration, example_count, failure_count, pending_count)
        @output.puts "\nFinished in #{duration} seconds\n"

        summary = "#{example_count} example#{'s' unless example_count == 1}, #{failure_count} failure#{'s' unless failure_count == 1}"
        summary << ", #{pending_count} pending" if pending_count > 0  

        if failure_count == 0
          if pending_count > 0
            @output.puts yellow(summary)
          else
            @output.puts green(summary)
          end
        else
          @output.puts red(summary)
        end
        @output.flush
      end

      def dump_pending
        unless @pending_examples.empty?
          @output.puts
          @output.puts "Pending:"
          @pending_examples.each do |pending_example, message|
            @output.puts "\n  #{pending_example.behaviour}\n  - #{pending_example.description}"
          end
        end
        @output.flush
      end

      def close
        if IO === @output && @output != $stdout
          @output.close 
        end
      end

      def format_backtrace(backtrace)
        return "" if backtrace.nil?
        cleansed = backtrace.map { |line| backtrace_line(line) }.compact.join("\n")
        cleansed.empty? ? backtrace : cleansed
      end

      protected

      def enable_color_in_output?
        @options.enable_color_in_output?
      end

      def backtrace_line(line)
        return nil if line.rindex(Micronaut::InstallDirectory, 0)
        line.sub!(/\A([^:]+:\d+)$/, '\\1')
        return nil if line == '-e:1'
        line
      end

      def color(text, color_code)
        return text unless enable_color_in_output?
        "#{color_code}#{text}\e[0m"
      end

      def green(text)
        color(text, "\e[32m")
      end

      def red(text)
        color(text, "\e[31m")
      end

      def magenta(text)
        color(text, "\e[35m")
      end

      def yellow(text)
        color(text, "\e[33m")
      end

      def blue(text)
        color(text, "\e[34m")
      end

    end
    
  end

end