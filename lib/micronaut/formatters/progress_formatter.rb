module Micronaut
  module Formatters
    
    class ProgressFormatter < BaseTextFormatter
      
      def example_failed(example, exception)
        super
        output.print colorise('F', exception)
        output.flush
      end

      def example_passed(example)
        super
        output.print green('.')
        output.flush
      end

      def example_pending(example, message)
        super
        output.print yellow('*')
        output.flush
      end

      def start_dump(duration)
        super
        output.puts
        output.flush
      end

      def method_missing(sym, *args)
        # ignore
      end
      
    end
    
  end
end