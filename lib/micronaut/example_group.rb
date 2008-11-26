require 'mocha/standalone'
require 'mocha/object'

module Micronaut
  class ExampleGroup
    include Micronaut::Matchers
    include Mocha::Standalone

    def self.inherited(klass)
      super
      Micronaut::ExampleWorld.example_groups << klass
    end
    
    def self.befores
      @_befores ||= { :all => [], :each => [] }
    end
    
    def self.before_eachs
      befores[:each]
    end
    
    def self.before_alls
      befores[:all]
    end
    
    def self.before(type=:each, &block)
      befores[type] << block
    end
    
    def self.afters
      @_afters ||= { :all => [], :each => [] }
    end
    
    def self.after_eachs
      afters[:each]
    end
    
    def self.after_alls
      afters[:all]
    end
    
    def self.after(type=:each, &block)
      @_afters ||= { :all => [], :each => [] }
      @_afters[type] << block
    end
    
    def self.it(desc=nil, options={}, &block)
      examples << [desc, options, block]
    end
    
    def self.examples
      @_examples ||= []
    end
    
    def self.set_it_up(name_or_const, desc, options)
      @name, @subject, @description, @options = name_or_const.to_s, name_or_const, desc, options
    end
    
    def self.name
      @name
    end
    
    def self.subject
      @subject
    end
    
    def self.description
      @description
    end
    
    def self.options
      @options
    end
    
    def self.describe(name_or_const, desc=nil, options={}, &block)
      subclass('NestedLevel') do
        set_it_up(name_or_const, desc, options)
        
        module_eval(&block)
      end
    end
    
    def self.create_example_group(name_or_const, desc=nil, options={}, &describe_block)
      describe(name_or_const, desc, options, &describe_block)
    end
    
    def self.each_ancestor(superclass_last=false)
      classes = []
      current_class = self
      while is_example_group_class?(current_class)
        superclass_last ? classes << current_class : classes.unshift(current_class)
        current_class = current_class.superclass
      end
      
      classes.each do |example_group|
        yield example_group
      end
    end
    
    def self.is_example_group_class?(klass)
      klass.kind_of?(Micronaut::ExampleGroup)
    end    
  
    def self.all_before_alls
      _before_alls = []
      each_ancestor do |ancestor|
        _before_alls << ancestor.befores[:all]
      end
      _before_alls
    end
    
    def self.run(runner)
      new.execute(runner)
    end

    def execute(runner)
      result = ''
      return result if self.class.examples.empty?
      self.class.all_before_alls.each { |aba| instance_eval(&aba) }
      
      self.class.examples.each do |desc, opts, block|
        execution_error = nil

        begin
          mocha_setup
          self.class.befores[:each].each { |be| instance_eval(&be) }
          if block
            result << '.'
            instance_eval(&block)
          else
            result << 'P'
          end
          mocha_verify
        rescue Exception => e
          runner.complain(self, e)
          execution_error ||= e
        ensure
          mocha_teardown
        end
        
        begin
          self.class.afters[:each].each { |ae| instance_eval(&ae) }
        rescue Exception => e
          runner.complain(self, e)
          execution_error ||= e
        end
      end
      result
      # options.reporter.example_finished(self, execution_error)
      # success = execution_error.nil? || ExamplePendingError === execution_error
    end
     
  end
end