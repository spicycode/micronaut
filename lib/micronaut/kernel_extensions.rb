module Micronaut
  module KernelExtensions

    def describe(*args, &describe_block)
      Micronaut::Behaviour.describe(*args, &describe_block)
    end

  end
end

include Micronaut::KernelExtensions