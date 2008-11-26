module Micronaut
  module ExampleGroupClassMethods
    
    def example_objects
      @example_objects ||= []
    end
    
    def create_example_group(name_or_const, options={}, &describe_block)
      example_group = new(name_or_const, options)
      example_group.instance_eval(&describe_block)
      Micronaut::ExampleWorld.example_groups << example_group
    end
    
    def example(description=nil, options={}, &example_block)
      e = new(description, options, &example_block)
      example_objects << e
      e
    end
    
  end
end