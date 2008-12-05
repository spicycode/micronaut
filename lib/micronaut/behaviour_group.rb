module Micronaut
  
  class BehaviourGroup
    include Micronaut::Matchers 

    def self.inherited(klass)
      super
      Micronaut::World.behaviour_groups << klass
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

    def self.before(type=:each, options={}, &block)
      befores[type] << [options, block]
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

    def self.after(type=:each, options={}, &block)
      afters[type] << [options, block]
    end

    def self.it(desc=nil, options={}, &block)
      examples << Micronaut::Example.new(self, desc, options, block)
    end

    def self.examples
      @_examples ||= []
    end

    def self.set_it_up(*args)
      metadata[:options] = args.last.is_a?(Hash) ? args.pop : {}
      metadata[:described_type] = args.first.is_a?(String) ? self.superclass.described_type : args.shift
      metadata[:description] = args.shift || ''
      metadata[:name] = "#{metadata[:described_type]} #{metadata[:description]}".strip
      
      Micronaut.configuration.find_modules(self).each do |include_or_extend, mod, opts|
        send(include_or_extend, mod)
      end
    end

    def self.metadata
      @_metadata ||= {}
    end

    def self.name
      metadata[:name]
    end

    def self.described_type
      metadata[:described_type]
    end

    def self.description
      metadata[:description]
    end

    def self.options
      metadata[:options]
    end

    def self.describe(*args, &describe_block)
      raise ArgumentError if args.empty? || describe_block.nil?
      subclass('NestedLevel') do
        set_it_up(*args)
        module_eval(&describe_block)
      end
    end

    def self.ancestors(superclass_last=false)
      classes = []
      current_class = self

      while current_class < Micronaut::BehaviourGroup
        superclass_last ? classes << current_class : classes.unshift(current_class)
        current_class = current_class.superclass
      end
      
      classes
    end
    
    def self.before_ancestors
      @_before_ancestors ||= ancestors 
    end
    
    def self.after_ancestors
      @_after_ancestors ||= ancestors(true)
    end

    def self.eval_before_alls(example)
      Micronaut.configuration.find_before_or_after(:before, :all, self).each { |blk| example.instance_eval(&blk) }
      
      before_ancestors.each do |ancestor| 
        ancestor.before_alls.each { |opts, blk| example.instance_eval(&blk) }
      end
    end
        
    def self.eval_before_eachs(example)
      Micronaut.configuration.find_before_or_after(:before, :each, self).each { |blk| example.instance_eval(&blk) }
      
      before_ancestors.each do |ancestor| 
        ancestor.before_eachs.each { |opts, blk| example.instance_eval(&blk) }
      end
    end

    def self.eval_after_alls(example)
      Micronaut.configuration.find_before_or_after(:after, :all, self).each { |blk| example.instance_eval(&blk) }
            
      after_ancestors.each do |ancestor| 
        ancestor.after_alls.each { |opts, blk| example.instance_eval(&blk) }
      end
    end

    def self.eval_after_eachs(example)
      Micronaut.configuration.find_before_or_after(:after, :each, self).each { |blk| example.instance_eval(&blk) }
      
      after_ancestors.each do |ancestor|
        ancestor.after_eachs.each { |opts, blk| example.instance_eval(&blk) }
      end
    end

    def self.run(reporter)
      return true if examples.empty?
      

      group = new
      eval_before_alls(group)
      success = true

      examples.each do |ex|
        reporter.example_started(ex)

        execution_error = nil
        begin
          group._setup_mocks
          eval_before_eachs(group)

          if ex.example_block
            group.instance_eval(&ex.example_block)
            group._verify_mocks
            reporter.example_passed(ex)
          else
            reporter.example_pending(ex, 'Not yet implemented')
          end
          eval_after_eachs(group)
        rescue Exception => e
          reporter.example_failed(ex, e)
          execution_error ||= e
        ensure
          group._teardown_mocks
        end

        success &= execution_error.nil?
      end
      eval_after_alls(group)
      success
    end

    def self.subclass(base_name, &body) # :nodoc:
      @_sub_class_count ||= 0
      @_sub_class_count += 1
      klass = Class.new(self)
      class_name = "#{base_name}_#{@_sub_class_count}"
      const_set(class_name, klass)
      klass.instance_eval(&body)
      klass
    end

    def self.to_s
      self == Micronaut::BehaviourGroup ? 'Micronaut::BehaviourGroup' : name
    end
    
  end
end
