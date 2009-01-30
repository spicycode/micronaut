module Micronaut

  module Formatters

    class BaseTextFormatter < BaseFormatter
            
      def example_passed(example)
        super
        # Why && @start_time
        if profile_examples? && @start_time
          example_profiling_info << [example, Time.now - @start_time] 
        end
      end
      
      def example_started(example)
        super
        @start_time = Time.now
      end

      def example_pending(example, message)
        pending_examples << [example, message]
      end

      def example_failed(example, exception)
        super
        failed_examples << [example, exception]
      end

      def dump_failures
        output.puts
        failed_examples.each_with_index do |examples_with_exception, index|
          failed_example, exception = examples_with_exception.first, examples_with_exception.last
          padding = '    '
          
          output.puts "#{index.next}) #{failed_example}"
          output.puts "#{padding}Failure/Error: #{read_failed_line(exception, failed_example).strip}"
          
          exception.message.split("\n").each do |line|
            output.puts "#{padding}#{colorise(line, exception).strip}"
          end

          format_backtrace(exception.backtrace, failed_example).each do |backtrace_info|
            output.puts grey("#{padding}# #{backtrace_info}")
          end
          
          output.puts 
          output.flush
        end
      end

      def colorise(s, failure)
        if failure.is_a?(Micronaut::Expectations::ExpectationNotMetError)
          red(s)
        else
          magenta(s)
        end
      end

      def dump_summary
        failure_count = failed_examples.size
        pending_count = pending_examples.size

        output.puts "\nFinished in #{duration} seconds\n"

        summary = "#{example_count} example#{'s' unless example_count == 1}, #{failure_count} failures"
        summary << ", #{pending_count} pending" if pending_count > 0  

        if failure_count == 0
          if pending_count > 0
            output.puts yellow(summary)
          else
            output.puts green(summary)
          end
        else
          output.puts red(summary)
        end
        
        # Don't print out profiled info if there are failures, it just clutters the output
        if profile_examples? && failure_count == 0
          sorted_examples = example_profiling_info.sort_by { |desc, time| time }.last(10)
          output.puts "\nTop #{sorted_examples.size} slowest examples:\n"        
          sorted_examples.reverse.each do |ex, time|
            output.puts "  (#{sprintf("%.7f", time)} seconds) #{ex}"
            output.puts grey("   # #{ex.metadata[:caller]}")
          end
        end
        
        output.flush
      end
      
      # def textmate_link_backtrace(path)
      #   file, line = path.split(':')
      #   "txmt://open/?url=file://#{File.expand_path(file)}&line=#{line}"
      # end

      def dump_pending
        unless pending_examples.empty?
          output.puts
          output.puts "Pending:"
          pending_examples.each do |pending_example, message|
            output.puts "  #{pending_example}"
            output.puts grey("   # #{pending_example.metadata[:caller]}")
          end
        end
        output.flush
      end

      def close
        if IO === output && output != $stdout
          output.close 
        end
      end

      protected

      def color(text, color_code)
        return text unless color_enabled?
        "#{color_code}#{text}\e[0m"
      end
      
      def bold(text)
        color(text, "\e[1m")
      end
      
      def white(text)
        color(text, "\e[37m")
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
      
      def grey(text)
        color(text, "\e[90m")
      end

    end
    
  end

end