module Micronaut
  class Behaviour
    include Micronaut::Matchers 
    
    attr_accessor :running_example
    
    def self.inherited(klass)
      super
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
      @metadata = { :behaviour => {} }
      extra_metadata = args.last.is_a?(Hash) ? args.pop : {}
      extra_metadata.delete(:behaviour) # Remove it when present to prevent it clobbering the one we setup
      
      @metadata[:behaviour][:describes] = args.shift unless args.first.is_a?(String)
      @metadata[:behaviour][:describes] ||= self.superclass.metadata && self.superclass.metadata[:behaviour][:describes]
      @metadata[:behaviour][:description] = args.shift || ''
      @metadata[:behaviour][:name] = "#{describes} #{description}".strip
      @metadata[:behaviour][:block] = extra_metadata.delete(:behaviour_block)
      @metadata[:behaviour][:caller] = eval("caller(0)[0]", @metadata[:behaviour][:block].binding)
      @metadata[:behaviour][:file_path] = @metadata[:behaviour][:caller].split(":")[0].strip
      @metadata[:behaviour][:line_number] = @metadata[:behaviour][:caller].split(":")[1].to_i
      
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
      @metadata
    end

    def self.name
      @metadata[:behaviour][:name]
    end

    def self.describes
      @metadata[:behaviour][:describes]
    end

    def self.description
      @metadata[:behaviour][:description]
    end
    
    def self.file_path
      @metadata[:behaviour][:file_path]
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
    rescue Exception => e # TODO not sure what to do about this case?
      nil
    end

    def self.run(reporter)
      return true if examples.empty?

      reporter.add_behaviour(self)
      
      group = new
      eval_before_alls(group)
      success = true

      examples_to_run.each do |ex|
        group.running_example = ex
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
        rescue Exception => e
          reporter.example_failed(ex, e)
          execution_error ||= e
        ensure
          eval_after_eachs(group)
          group._teardown_mocks
        end

        success &= execution_error.nil?
      end
      eval_after_alls(group)
      group.running_example = nil
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
      self == Micronaut::Behaviour ? 'Micronaut::Behaviour' : @metadata[:behaviour][:name]
    end
    
  end
end