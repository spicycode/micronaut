module Micronaut

  class Configuration
    # Desired mocking framework - expects the symbol name of the framework
    # Currently supported: :mocha, :rr, or nothing (the default if this is not set at all)
    attr_reader :mock_framework
    
    # Array of regular expressions to scrub from backtrace
    attr_reader :backtrace_clean_patterns
    
    # An array of arrays to store before and after blocks
    attr_reader :before_and_afters

    # Filters allow you to exclude or include certain examples from running based on options you pass in 
    attr_reader :filters
    
    # When this is true, if you have filters enabled and no examples match, 
    # all examples are added and run - defaults to true
    attr_accessor :run_all_when_everything_filtered

    # Enable profiling of the top 10 slowest examples - defaults to false
    attr_accessor :profile_examples
    
    
    def initialize
      @backtrace_clean_patterns = [/\/lib\/ruby\//, /bin\/rcov:/, /vendor\/rails/]
      @profile_examples = false
      @run_all_when_everything_filtered = true
      @filters = []
      @before_and_afters = []
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
    
    # Determines whether or not any output should include ANSI color codes,
    # defaults to true
    def color_enabled?
      @color_enabled || true
    end
    
    def color_enabled=(on_or_off)
      @color_enabled = on_or_off
    end
    
    # The formatter to use.  Defaults to the documentation formatter
    def formatter=(formatter_to_use)
      @formatter_to_use = formatter_to_use.to_s
    end
    
    def formatter
      @formatter ||= case @formatter_to_use
                     when 'documentation'
                       Micronaut::Formatters::DocumentationFormatter.new
                     else
                       Micronaut::Formatters::ProgressFormatter.new
                     end
    end
    
    def output
      $stdout
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
    
    def add_filter(options={})
      filters << options
    end
    
    def run_all_when_everything_filtered?
      @run_all_when_everything_filtered
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
