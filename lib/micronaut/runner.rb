module Micronaut

  class Runner

    def self.installed_at_exit?
      @installed_at_exit ||= false
    end

    def self.autorun
      at_exit { Micronaut::Runner.new.run(ARGV) ? exit(0) : exit(1) } unless installed_at_exit?
      @installed_at_exit = true
    end
    
    def configuration
      Micronaut.configuration
    end
    
    def formatter
      Micronaut.configuration.formatter
    end
    
    def require_all_behaviours(files_from_args=[])
      files_from_args.each { |file| require file }
    end
    
    def run(args = [])
      require_all_behaviours(args)
      
      behaviours_to_run = Micronaut.world.behaviours_to_run

      total_examples = behaviours_to_run.inject(0) { |sum, b| sum + b.examples_to_run.size }

      old_sync, formatter.output.sync = formatter.output.sync, true if formatter.output.respond_to?(:sync=)

      formatter.start(total_examples)

      suite_success = true

      starts_at = Time.now
      behaviours_to_run.each do |behaviour|
        suite_success &= behaviour.run(formatter)
      end
      duration = Time.now - starts_at

      formatter.start_dump
      formatter.dump_failures
      # TODO: Stop passing in the last two items, the formatter knows this info
      formatter.dump_summary(duration, total_examples, formatter.failed_examples.size, formatter.pending_examples.size)
      formatter.dump_pending

      formatter.output.sync = old_sync if formatter.output.respond_to? :sync=

      suite_success
    end

  end

end
