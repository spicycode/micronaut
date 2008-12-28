module Micronaut

  class Example
  
    attr_reader :behaviour, :description, :metadata, :example_block
  
    def initialize(behaviour, desc, options, example_block=nil)
      @behaviour, @description, @options, @example_block = behaviour, desc, options, example_block
      @metadata = @behaviour.metadata.dup
      @metadata[:description] = description
      @metadata.update(options)
    end

    def inspect
      "#{@metadata[:behaviour][:name]} - #{@metadata[:description]}"
    end
    
    def to_s
      inspect
    end
  
  end
  
end