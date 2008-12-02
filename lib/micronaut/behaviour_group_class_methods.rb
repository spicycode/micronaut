module Micronaut
  module BehaviourGroupClassMethods
    
    def inherited(klass)
      super
      Micronaut::World.behaviour_groups << klass
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
      metadata[:options] = args.last.is_a?(Hash) ? args.pop : {}
      metadata[:described_type] = args.first.is_a?(String) ? self.superclass.described_type : args.shift
      metadata[:description] = args.shift || ''
      metadata[:name] = "#{metadata[:described_type]} #{metadata[:description]}".strip
    end
    
    def metadata
      @_metadata ||= {}
    end
    
    def name
      metadata[:name]
    end
    
    def described_type
      metadata[:described_type]
    end
    
    def description
      metadata[:description]
    end
    
    def options
      metadata[:options]
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
      const_set(class_name, klass)
      klass.instance_eval(&body)
      klass
    end
    
    def to_s
      name
    end
    
  end
end