module Micronaut

  class Configuration
    attr_reader :mock_framework
    
    def mock_with(make_a_mockery_with=nil)
      @mock_framework = case make_a_mockery_with
                        when :mocha
                          Micronaut::Mocking::WithMocha
                        else
                          Micronaut::Mocking::WithAbsolutelyNothing
                        end 

      Micronaut::BehaviourGroup.send(:include, @mock_framework)
    end
    
    def include(module_to_include, options={})
      Micronaut::BehaviourGroup.send(:include, module_to_include)
    end
    
    def extend(module_to_extend, options={})
      Micronaut::BehaviourGroup.send(:extend, module_to_extend)
    end
    
    def before(type=:each, options={}, &block)
      
    end
    
    def after(type=:each, options={}, &block)
      
    end
    
  end
  
end