module Micronaut

  class RunnerOptions
    
    attr_accessor :color, :formatter
    
    def initialize(options={})
      @color = options.delete(:color)
      @formatter = options.delete(:formatter)
    end
    
    def enable_color_in_output?
      @color
    end
    
    def output
      $stdout
    end
    
    def formatter
      @formatter_instance ||= Micronaut::Formatters::ProgressFormatter.new(self, output)
    end

  end
  
end