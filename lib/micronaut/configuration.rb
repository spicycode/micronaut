module Micronaut

  class Configuration
    # Regex patterns to scrub backtrace with
    attr_reader :backtrace_clean_patterns
    
    # All of the defined before/after blocks setup in the configuration
    attr_reader :before_and_afters
    
    # Allows you to control what examples are ran by filtering 
    attr_reader :filter
    
    # Modules that will be included or extended based on given filters
    attr_reader :include_or_extend_modules
    
    # Run all examples if the run is filtered, and no examples were found - defaults to true
    attr_accessor :run_all_when_everything_filtered

    # Enable profiling of example run - defaults to false
    attr_accessor :profile_examples
    
    attr_reader :mock_framework
    
    def initialize
      @backtrace_clean_patterns = [/\/lib\/ruby\//, /bin\/rcov:/, /vendor\/rails/, /bin\/micronaut/, /#{::Micronaut::InstallDirectory}/]
      @profile_examples = false
      @run_all_when_everything_filtered = true
      @color_enabled = false
      @before_and_afters = { :before => { :each => [], :all => [] }, :after => { :each => [], :all => [] } }
      @include_or_extend_modules = []
      @formatter_to_use = Micronaut::Formatters::ProgressFormatter
      @filter = nil
    end
    
    # E.g. alias_example_to :crazy_slow, :speed => 'crazy_slow' defines
    # crazy_slow as an example variant that has the crazy_slow speed option
    def alias_example_to(new_name, extra_options={})
      Micronaut::Behaviour.alias_example_to(new_name, extra_options)
    end
        
    def cleaned_from_backtrace?(line)
      @backtrace_clean_patterns.any? { |regex| line =~ regex }
    end
    
    def mock_with(make_a_mockery_with=nil)
      @mock_framework = make_a_mockery_with
      mock_framework_class = case make_a_mockery_with.to_s
                             when /mocha/i
                               require 'micronaut/mocking/with_mocha'
                               Micronaut::Mocking::WithMocha
                             when /rr/i
                               require 'micronaut/mocking/with_rr'
                               Micronaut::Mocking::WithRR
                             else
                               require 'micronaut/mocking/with_absolutely_nothing'
                               Micronaut::Mocking::WithAbsolutelyNothing
                             end 

      Micronaut::Behaviour.send(:include, mock_framework_class)
    end
    
    def autorun!
      Micronaut::Runner.autorun
    end
       
    def color_enabled=(on_or_off)
      @color_enabled = on_or_off
    end
    
    # Output with ANSI color enabled? Defaults to false
    def color_enabled?
      @color_enabled
    end
    
    def filter_run(options={})
      @filter = options
    end
    
    def run_all_when_everything_filtered?
      @run_all_when_everything_filtered
    end
    
    def formatter=(formatter_to_use)
      @formatter_to_use = case formatter_to_use.to_s
                          when 'documentation' then Micronaut::Formatters::DocumentationFormatter
                          when 'progress' then Micronaut::Formatters::ProgressFormatter
                          end
    end
    
    # The formatter all output should use.  Defaults to the progress formatter
    def formatter
      @formatter ||= @formatter_to_use.new
    end
    
    # Where does output go? For now $stdout
    def output
      $stdout
    end

    # RJS I think we should rename include/extend so they don't conflict or confuse with the ruby builtin
    #  maybe register_include, setup_include, add_include, or just _include ?
    def include(mod, options={})
      include_or_extend_modules << [:include, mod, options]
    end
    
    def extend(mod, options={})
      include_or_extend_modules << [:extend, mod, options]
    end
    
    def find_modules(group)
      include_or_extend_modules.select do |include_or_extend, mod, options|
        options.all? do |filter_on, filter|
          Micronaut.world.apply_condition(filter_on, filter, group.metadata)
        end
      end
    end
          
    def before(each_or_all=:each, options={}, &block)
      before_and_afters[:before][each_or_all] << [options, block]
    end
    
    def after(each_or_all=:each, options={}, &block)
      before_and_afters[:after][each_or_all] << [options, block]
    end
    
    def find_before_or_after(desired_type, desired_each_or_all, group)
      before_and_afters[desired_type][desired_each_or_all].select do |options, block|
        options.all? do |filter_on, filter|
          Micronaut.world.apply_condition(filter_on, filter, group.metadata)
        end
      end.map { |options, block| block }
    end
    
  end
  
end