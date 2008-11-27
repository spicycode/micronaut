module Micronaut
  module Extensions
    module Kernel

      def describe(name_or_const, desc=nil, options={}, &describe_block)
        Micronaut::BehaviourGroup.create_example_group(name_or_const, desc, options, &describe_block)
      end

    end
  end
end

include Micronaut::Extensions::Kernel