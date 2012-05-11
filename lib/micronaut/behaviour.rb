module Micronaut
  class Behaviour
    include Micronaut::Matchers 
    
    attr_accessor :running_example, :reporter
    
    def self.inherited(klass)
      super
      Micronaut.configuration.autorun!
      Micronaut.world.behaviours << klass
    end
    
    def self.extended_modules #:nodoc:
      ancestors = class << self; ancestors end
      ancestors.select { |mod| mod.class == Module } - [ Object, Kernel ]
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
      afters[type] << block
    end

    def self.example(desc=nil, options={}, &block)
      examples << Micronaut::Example.new(self, desc, options.update(:caller => caller[0]), block)
    end
        
    def self.alias_example_to(new_alias, extra_options={})
      new_alias = <<-END_RUBY
                    def self.#{new_alias}(desc=nil, options={}, &block)
                      updated_options = options.update(:caller => caller[0])
                      updated_options.update(#{extra_options.inspect})
                      block = nil if updated_options[:pending] == true || updated_options[:disabled] == true
                      examples << Micronaut::Example.new(self, desc, updated_options, block)
                    end
                  END_RUBY
      module_eval(new_alias, __FILE__, __LINE__)
    end

    alias_example_to :it
    alias_example_to :focused, :focused => true
    alias_example_to :disabled, :disabled => true
    alias_example_to :pending, :pending => true
    
    def self.examples
      @_examples ||= []
    end
    
    def self.examples_to_run
      @_examples_to_run ||= []
    end

    def self.set_it_up(*args)
      @metadata = { }
      extra_metadata = args.last.is_a?(Hash) ? args.pop : {}
      extra_metadata.delete(:behaviour) # Remove it when present to prevent it clobbering the one we setup
      @metadata.update(self.superclass.metadata) 
      @metadata[:behaviour] = {}
      @metadata[:behaviour][:describes] = args.shift unless args.first.is_a?(String)
      @metadata[:behaviour][:describes] ||= self.superclass.metadata && self.superclass.metadata[:behaviour][:describes]
      @metadata[:behaviour][:description] = args.shift || ''
      @metadata[:behaviour][:name] = "#{describes} #{description}".strip
      @metadata[:behaviour][:block] = extra_metadata.delete(:behaviour_block)
      @metadata[:behaviour][:caller] = extra_metadata.delete(:caller) || caller(1)
      @metadata[:behaviour][:file_path] = extra_metadata.delete(:file_path) || @metadata[:behaviour][:caller][4].split(":")[0].strip
      @metadata[:behaviour][:line_number] = extra_metadata.delete(:line_number) || @metadata[:behaviour][:caller][4].split(":")[1].to_i
      
      @metadata.update(extra_metadata)
      
      Micronaut.configuration.find_modules(self).each do |include_or_extend, mod, opts|                                                                                                                                                                               
        if include_or_extend == :extend
          send(:extend, mod) unless extended_modules.include?(mod)                                                                                                                                                                                                    
        else
          send(:include, mod) unless included_modules.include?(mod)
        end
      end
    end

    def self.metadata
      @metadata ||= { :behaviour => {} }
    end

    def self.name(friendly=true)
      friendly ? metadata[:behaviour][:name] : super()
    end

    def self.describes
      metadata[:behaviour][:describes]
    end

    def self.description
      metadata[:behaviour][:description]
    end
    
    def self.file_path
      metadata[:behaviour][:file_path]
    end
   
    def self.describe(*args, &behaviour_block)
      raise(ArgumentError, "No arguments given.  You must a least supply a type or description") if args.empty? 
      raise(ArgumentError, "You must supply a block when calling describe") if behaviour_block.nil?
      
      subclass('NestedLevel') do
        args << {} unless args.last.is_a?(Hash)
        args.last.update(:behaviour_block => behaviour_block)
        set_it_up(*args)
        module_eval(&behaviour_block)
      end
    end

    def self.ancestors(superclass_last=false)
      classes = []
      current_class = self

      while current_class < Micronaut::Behaviour
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

    def self.before_all_ivars
      @before_all_ivars ||= {}
    end

    def self.eval_before_alls(running_behaviour)
      superclass.before_all_ivars.each { |ivar, val| running_behaviour.instance_variable_set(ivar, val) }
      Micronaut.configuration.find_before_or_after(:before, :all, self).each { |blk| running_behaviour.instance_eval(&blk) }
      
      before_alls.each { |blk| running_behaviour.instance_eval(&blk) }
      running_behaviour.instance_variables.each { |ivar| before_all_ivars[ivar] = running_behaviour.instance_variable_get(ivar) }
    end
        
    def self.eval_before_eachs(running_behaviour)
      Micronaut.configuration.find_before_or_after(:before, :each, self).each { |blk| running_behaviour.instance_eval(&blk) }
      before_ancestors.each { |ancestor| ancestor.before_eachs.each { |blk| running_behaviour.instance_eval(&blk) } }
    end

    def self.eval_after_alls(running_behaviour)
      after_alls.each { |blk| running_behaviour.instance_eval(&blk) }
      Micronaut.configuration.find_before_or_after(:after, :all, self).each { |blk| running_behaviour.instance_eval(&blk) }
      before_all_ivars.keys.each { |ivar| before_all_ivars[ivar] = running_behaviour.instance_variable_get(ivar) }
    end

    def self.eval_after_eachs(running_behaviour)
      after_ancestors.each { |ancestor| ancestor.after_eachs.each { |blk| running_behaviour.instance_eval(&blk) } }
      Micronaut.configuration.find_before_or_after(:after, :each, self).each { |blk| running_behaviour.instance_eval(&blk) }
    end

    def self.run(reporter)
      behaviour_instance = new
      reporter.add_behaviour(self)
      eval_before_alls(behaviour_instance)
      success = run_examples(behaviour_instance, reporter)
      eval_after_alls(behaviour_instance)
      
      success
    end
    
    # Runs all examples, returning true only if all of them pass
    def self.run_examples(behaviour_instance, reporter)
      examples_to_run.map { |ex| ex.run(behaviour_instance) }.all?
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
      self == Micronaut::Behaviour ? 'Micronaut::Behaviour' : name
    end
   
  end
end
