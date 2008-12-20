module Micronaut
  class RunnerOptions
    
    attr_accessor :color
    
    def initialize(options={})
      @color = options.delete(:color)
      @formatter = options.delete(:formatter)
    end
    
    def enable_color_in_output?
      !textmate? && @color
    end
    
    def textmate?
      ENV.has_key?('TM_RUBY')
    end
    
    def output
      $stdout
    end
    
    def formatter
      @formatter_instance ||= case @formatter.to_s
                              when 'documentation'
                                Micronaut::Formatters::DocumentationFormatter.new(self, output)
                              else
                                Micronaut::Formatters::ProgressFormatter.new(self, output)
                              end
    end

  end
end