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
      
    end
    
    def before(type=:each, options={}, &block)
      
    end
    
    def after(type=:each, options={}, &block)
      
    end
    
  end
  
end