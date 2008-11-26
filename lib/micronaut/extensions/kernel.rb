module Micronaut
  module Extensions
    module Kernel

      def describe(name_or_const, options={}, &describe_block)
        Micronaut::ExampleGroup.create_example_group(name_or_const, options, &describe_block)
      end

    end
  end
end

include Micronaut::Extensions::Kernel