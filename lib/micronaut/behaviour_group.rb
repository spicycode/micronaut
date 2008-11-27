module Micronaut
  class BehaviourGroup
    extend Micronaut::BehaviourGroupClassMethods
    include Micronaut::Matchers
    include Micronaut::Mocking::WithMocha

    def execute(runner)
      result = ''
      return result if self.class.examples.empty?
      self.class.all_before_alls.each { |aba| instance_eval(&aba) }
      
      self.class.examples.each do |desc, opts, block|
        execution_error = nil

        begin
          setup_mocks
          self.class.befores[:each].each { |be| instance_eval(&be) }
          if block
            result << '.'
            instance_eval(&block)
          else
            result << 'P'
          end
          verify_mocks
        rescue Exception => e
          runner.complain(self, e)
          execution_error ||= e
        ensure
          teardown_mocks
        end
        
        begin
          self.class.afters[:each].each { |ae| instance_eval(&ae) }
        rescue Exception => e
          runner.complain(self, e)
          execution_error ||= e
        end
      end
      result
    end
     
  end
end