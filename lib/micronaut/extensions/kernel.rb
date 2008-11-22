module Micronaut
  module Extensions
    module Kernel

      def describe(name_or_const, desc=nil, &describe_block)
        # Micronaut::ExampleGroup.create_example_group(name_or_const, desc, &describe_block)
        example_group = Micronaut::ExampleGroup.new(name_or_const, desc)
        example_group.instance_eval(&describe_block)
        Micronaut::ExampleWorld.example_groups << example_group
        # example_group = Micronaut::ExampleGroup.new(name_or_const, desc)
        # example_group.instance_eval(&describe_block)
        # Micronaut::ExampleWorld.example_groups << example_group
      end

    end
  end
end

include Micronaut::Extensions::Kernel