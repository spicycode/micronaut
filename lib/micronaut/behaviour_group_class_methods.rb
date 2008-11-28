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
    
    def set_it_up(*args)
      @_behaviour_group_options = args.last.is_a?(Hash) ? args.pop : {}
      @_behaviour_described_type = args.first.is_a?(String) ? self.superclass.described_type : args.shift
      @_behaviour_group_description = args.shift || ''      
    end
    
    def name
      "#{@_behaviour_described_type} #{@_behaviour_group_description}".strip
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
    
    def describe(*args, &describe_block)
      raise ArgumentError if args.empty? || describe_block.nil?
      
      args << {} unless Hash === args.last
     # args.last[:spec_path] ||= File.expand_path(caller(0)[2])
      
      subclass('NestedLevel') do
        set_it_up(*args)
        module_eval(&describe_block)
      end
    end
    
    def each_ancestor(superclass_last=false)
      classes = []
      current_class = self

      while current_class < Micronaut::BehaviourGroup
        superclass_last ? classes << current_class : classes.unshift(current_class)
        current_class = current_class.superclass
      end
      
      classes.each { |example_group| yield example_group }
    end
  
    def run(runner)
      new.execute(runner)
    end
    
    def subclass(base_name, &body) # :nodoc:
      @_sub_class_count ||= 0
      @_sub_class_count += 1
      klass = Class.new(self)
      class_name = "#{base_name}_#{@_sub_class_count}"
      instance_eval { const_set(class_name, klass) }
      klass.instance_eval(&body)
      klass
    end
    
  end
end