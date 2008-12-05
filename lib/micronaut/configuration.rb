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
    
    def befores
      @befores ||= { :each => [], :all => {} }
    end
    
    def afters
      @afters ||= { :each => [], :all => {} }
    end
    
    def extra_modules
      @extra_modules ||= { :include => [], :extend => [] }
    end
    
    def include(module_to_include, options={})
      extra_modules[:include] << [module_to_include, options]
    end
    
    def extend(module_to_extend, options={})
      extra_modules[:extend] << [module_to_extend, options]
    end
    
    def before(type=:each, options={}, &block)
      befores[type] << [options, block]
    end
    
    def after(type=:each, options={}, &block)
      afters[type] << [options, block]
    end
    
  end
  
end