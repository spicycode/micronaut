module Micronaut
  module KernelExtensions

    def describe(*args, &behaviour_block)
      Micronaut::Behaviour.describe(*args, &behaviour_block)
    end

  end
end

include Micronaut::KernelExtensions