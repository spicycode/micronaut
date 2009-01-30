module Micronaut

  class Example
  
    attr_reader :behaviour, :description, :metadata, :example_block
  
    def initialize(behaviour, desc, options, example_block=nil)
      @behaviour, @description, @options, @example_block = behaviour, desc, options, example_block
      @metadata = @behaviour.metadata.dup
      @metadata[:description] = description
      @metadata.update(options)
    end

    def inspect
      "#{@metadata[:behaviour][:name]} - #{@metadata[:description]}"
    end
    
    def to_s
      inspect
    end

    def run_before_each
      @behaviour_instance._setup_mocks if @behaviour_instance.respond_to?(:_setup_mocks)
      @behaviour.eval_before_eachs(@behaviour_instance)
    end

    def run_after_each
      @behaviour.eval_after_eachs(@behaviour_instance)
      @behaviour_instance._verify_mocks if @behaviour_instance.respond_to?(:_verify_mocks)
    ensure
      @behaviour_instance._teardown_mocks if @behaviour_instance.respond_to?(:_teardown_mocks)
    end

    def run_example
      if example_block
        @behaviour_instance.instance_eval(&example_block)
        @reporter.example_passed(self)
      else
        @reporter.example_pending(self, 'Not yet implemented')
      end
    end

    def run(behaviour_instance, reporter)
      @behaviour_instance, @reporter = behaviour_instance, reporter
      @behaviour_instance.running_example = self
      @reporter.example_started(self)

      all_systems_nominal = true
      exception_encountered = nil
      
      begin
        run_before_each
        run_example
      rescue Exception => e
        exception_encountered = e
        all_systems_nominal = false
      end

      begin
        run_after_each
      rescue Exception => e
        exception_encountered ||= e
        all_systems_nominal = false
      ensure
        @behaviour_instance.running_example = nil
      end
      
      @reporter.example_failed(self, exception_encountered) if exception_encountered 

      all_systems_nominal
    end
  
  end
  
end
