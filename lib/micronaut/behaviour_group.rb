module Micronaut
  class BehaviourGroup
    extend Micronaut::BehaviourGroupClassMethods
    include Micronaut::Matchers
    include Micronaut::Mocking::WithMocha

  end
end