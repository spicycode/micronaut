module Micronaut
  class BehaviourGroup
    extend Micronaut::BehaviourGroupClassMethods
    include Micronaut::Matchers
    include Micronaut::Mocking::WithMocha

    def eval_before_alls
      self.class.each_ancestor do |ancestor| 
        ancestor.before_alls.each { |blk| instance_eval(&blk) }
      end
    end

    def eval_after_alls
      self.class.each_ancestor(:superclass_first) do |ancestor| 
        ancestor.after_alls.each { |blk| instance_eval(&blk) }
      end
    end

    def eval_before_eachs
      self.class.each_ancestor do |ancestor| 
        ancestor.before_eachs.each { |blk| instance_eval(&blk) }
      end
    end

    def eval_after_eachs
      self.class.each_ancestor(:superclass_first) do |ancestor|
        ancestor.after_eachs.each { |blk| instance_eval(&blk) }
      end
    end

    def execute(reporter)
      return true if self.class.examples.empty?
      eval_before_alls
      success = true

      self.class.examples.each do |desc, opts, block|
        reporter.example_started(self)

        execution_error = nil
        begin
          setup_mocks
          eval_before_eachs
          if block
            instance_eval(&block)
            reporter.example_passed(self)
          else
            reporter.example_pending([desc, self], 'Not yet implemented')
          end
        rescue Exception => e
          reporter.example_failed(self, e)
          execution_error ||= e
        end

        begin
          eval_after_eachs
          verify_mocks
        rescue Exception => e
          execution_error ||= e
        ensure
          teardown_mocks
        end

        success &= execution_error.nil?
      end
      eval_after_alls
      success
    end

  end
end