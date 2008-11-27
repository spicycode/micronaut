module Micronaut
  module Extensions
    module Kernel

      def describe(*args, &describe_block)
        Micronaut::BehaviourGroup.describe(*args, &describe_block)
      end

    end
  end
end

include Micronaut::Extensions::Kernel