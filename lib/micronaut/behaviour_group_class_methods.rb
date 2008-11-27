module Micronaut
  module BehaviourGroupClassMethods
    
    def inherited(klass)
      super
      Micronaut::ExampleWorld.example_groups << klass
    end
    
    def befores
      @_befores ||= { :all => [], :each => [] }
    end
    
    def before_eachs
      befores[:each]
    end
    
    def before_alls
      befores[:all]
    end
    
    def before(type=:each, &block)
      befores[type] << block
    end
    
    def afters
      @_afters ||= { :all => [], :each => [] }
    end
    
    def after_eachs
      afters[:each]
    end
    
    def after_alls
      afters[:all]
    end
    
    def after(type=:each, &block)
      afters[type] << block
    end
    
    def it(desc=nil, options={}, &block)
      examples << [desc, options, block]
    end
    
    def examples
      @_examples ||= []
    end
    
    def set_it_up(name_or_const, given_description, given_options)
      @_behaviour_group_name = name_or_const.to_s
      @_behaviour_described_type = name_or_const.is_a?(String) ? Object : name_or_const
      @_behaviour_group_description = given_description
      @_behaviour_group_options =  given_options
    end
    
    def name
      @_behaviour_group_name
    end
    
    def described_type
      @_behaviour_described_type
    end
    
    def description
      @_behaviour_group_description
    end
    
    def options
      @_behaviour_group_options
    end
    
    def describe(name_or_const, desc=nil, options={}, &block)
      raise ArgumentError if block.nil? || name_or_const.nil?
      
      subclass('NestedLevel') do
        set_it_up(name_or_const, desc, options)
        
        module_eval(&block)
      end
    end
    
    def create_example_group(name_or_const, desc=nil, options={}, &describe_block)
      describe(name_or_const, desc, options, &describe_block)
    end
    
    def each_ancestor(superclass_last=false)
      classes = []
      current_class = self
      #puts "each_ancestor(self) => #{self.inspect}\n"
      while is_example_group_class?(current_class)
        superclass_last ? classes << current_class : classes.unshift(current_class)
        current_class = current_class.superclass
        #puts "each_ancestor considering #{current_class.inspect}\n"
        current_class
      end
      
      classes.each do |example_group|
        yield example_group
      end
    end
    
    def is_example_group_class?(klass)
      # require 'pp'
      #    pp klass.class
      #puts "#{klass.to_s}.kind_of?(Micronaut::BehaviourGroup) => #{klass.kind_of?(Micronaut::BehaviourGroup)}"
      klass < Micronaut::BehaviourGroup
    end    
  
    def run(runner)
      new.execute(runner)
    end
    
    def subclass(base_name, &body)
      klass = Class.new(self)
      class_name = "#{base_name}_#{_sub_class_count!}"
      instance_eval do
        const_set(class_name, klass)
      end
      klass.instance_eval(&body) if block_given?
      klass
    end
    
    def subclass(base_name, &body) # :nodoc:
      @_sub_class_count ||= 0
      @_sub_class_count += 1
      klass = Class.new(self)
      class_name = "#{base_name}_#{@_sub_class_count}"
      instance_eval do
        const_set(class_name, klass)
      end
      klass.instance_eval(&body)
      klass
    end
    
  end
end