module Micronaut
  class BehaviourGroup
    extend Micronaut::BehaviourGroupClassMethods
    include Micronaut::Matchers
    include Micronaut::Mocking::WithMocha

    def execute(reporter)
      return true if self.class.examples.empty?
      self.class.all_before_alls.each { |aba| instance_eval(&aba) }
      
      success = true
      
      self.class.examples.each do |desc, opts, block|
        execution_error = nil
        reporter.example_started(self)
        
        begin
          setup_mocks
          self.class.befores[:each].each { |be| instance_eval(&be) }
          if block
            instance_eval(&block)
            reporter.example_passed(self)
          else
            reporter.example_pending([desc, self], 'Not yet implemented')
          end
          verify_mocks
        rescue Exception => e
          reporter.example_failed(self, e)
          execution_error ||= e
        ensure
          teardown_mocks
        end
        
        begin
          self.class.afters[:each].each { |ae| instance_eval(&ae) }
        rescue Exception => e
          execution_error ||= e
        end
        
        success &= execution_error.nil?
      end
      
      success
    end
     
  end
end