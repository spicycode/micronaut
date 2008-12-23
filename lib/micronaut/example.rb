module Micronaut

  class Example
  
    attr_reader :behaviour, :description, :metadata, :example_block
  
    def initialize(behaviour, desc, options, example_block=nil)
      @behaviour, @description, @options, @example_block = behaviour, desc, options, example_block
      @metadata = {}
      behaviour.metadata.each do |k, v|
        @metadata[k] = v
      end
      @metadata[:description] = description
      options.each do |k,v|
        @metadata[k] = v
      end
          #       
          # if @metadata[:options].has_key?(:focused)
          #   puts "self.inspect => #{self.inspect}"
          #   puts "@metadata[:description] => #{@metadata[:description]}"
          #   puts "@options.has_key?(:focused) => #{@options.has_key?(:focused)}"
          #   puts "@metadata[:options].has_key?(:focused) => #{@metadata[:options].has_key?(:focused)}"
          #   puts
          # end
    end

    def inspect
      "#{behaviour.name} - #{description}"
    end
    
    def to_s
      inspect
    end
  
  end
  
end