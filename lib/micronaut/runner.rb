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

      total_examples_to_run = Micronaut.world.total_examples_to_run

      old_sync, formatter.output.sync = formatter.output.sync, true if formatter.output.respond_to?(:sync=)

      suite_success = true

      formatter_supports_sync = formatter.output.respond_to?(:sync=)
      old_sync, formatter.output.sync = formatter.output.sync, true if formatter_supports_sync

      formatter.start(total_examples_to_run)

      starts_at = Time.now
      Micronaut.world.behaviours_to_run.each do |behaviour|
        suite_success &= behaviour.run(formatter)
      end
      duration = Time.now - starts_at

      formatter.start_dump
      formatter.dump_failures
      # TODO: Stop passing in the last two items, the formatter knows this info
      formatter.dump_summary(duration, total_examples_to_run)
      formatter.dump_pending
      formatter.close
      
      formatter.output.sync = old_sync if formatter_supports_sync

      suite_success
    end

  end

end
