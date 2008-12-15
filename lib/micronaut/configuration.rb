module Micronaut

  class Configuration
    attr_reader :mock_framework, :backtrace_clean_patterns, :behaviour_filters
    
    def initialize
      @backtrace_clean_patterns = [/\/lib\/ruby\//, /bin\/rcov:/, /vendor\/rails/]
    end
    
    def cleaned_from_backtrace?(line)
      return true if line.starts_with?(::Micronaut::InstallDirectory)
      
      @backtrace_clean_patterns.any? do |pattern|
        line =~ pattern
      end
    end
    
    def mock_with(make_a_mockery_with=nil)
      @mock_framework = case make_a_mockery_with
                        when :mocha
                          require 'micronaut/mocking/with_mocha'
                          Micronaut::Mocking::WithMocha
                        when :rr
                          require 'micronaut/mocking/with_rr'
                          Micronaut::Mocking::WithRR
                        else
                          Micronaut::Mocking::WithAbsolutelyNothing
                        end 

      Micronaut::Behaviour.send(:include, @mock_framework)
    end
    
    def autorun!
      Micronaut::Runner.autorun unless Micronaut::Runner.installed_at_exit?      
    end
    
    def options=(new_options)
      raise ArguementError unless new_options.is_a?(Micronaut::RunnerOptions)
      @options = new_options
    end
    
    def options
      @options ||= Micronaut::RunnerOptions.new(:color => true, :formatter => :documentation)
    end
    
    def extra_modules
      @extra_modules ||= []
    end
        
    def include(module_to_include, options={})
      extra_modules << [:include, module_to_include, options]
    end
    
    def extend(module_to_extend, options={})
      extra_modules << [:extend, module_to_extend, options]
    end
    
    def find_modules(group)
      extra_modules.select do |include_or_extend, mod, options|
        options.all? do |key, value|
          case value
          when Hash
            value.all? { |k, v| group.metadata[key][k] == v }
          when Regexp
            group.metadata[key] =~ value
          when Proc
            value.call(group.metadata[key]) rescue false
          else
            group.metadata[key] == value
          end
        end
      end
    end
    
    def filters
      @filters ||= []
    end
    
    def add_filter(options={})
      filters << options
    end
    
    def before_and_afters
      @before_and_afters ||= []
    end
    
    def before(type=:each, options={}, &block)
      before_and_afters << [:before, :each, options, block]
    end
    
    def after(type=:each, options={}, &block)
      before_and_afters << [:after, :each, options, block]
    end
    
    def find_before_or_after(desired_type, desired_each_or_all, group)
      before_and_afters.select do |type, each_or_all, options, block|
        type == desired_type && each_or_all == desired_each_or_all &&
        options.all? do |key, value|
          case value
          when Hash
            value.all? { |k, v| group.metadata[key][k] == v }
          when Regexp
            group.metadata[key] =~ value
          when Proc
            value.call(group.metadata[key]) rescue false
          else
            group.metadata[key] == value
          end
        end
      end.map { |type, each_or_all, options, block| block }
    end
    
  end
  
end
