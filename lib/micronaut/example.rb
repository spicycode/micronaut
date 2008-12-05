module Micronaut

  class Example
  
    attr_reader :behaviour, :description, :options, :example_block
  
    def initialize(behaviour, desc, options, example_block=nil)
      @behaviour, @description, @options, @example_block = behaviour, desc, options, example_block
    end
    
    def inspect
      "#{behaviour.name} - #{description}"
    end
    
    def to_s
      inspect
    end
  
  end
  
end