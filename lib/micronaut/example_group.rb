module Micronaut
  class ExampleGroup
    include Micronaut::Matchers
    include Micronaut::Mocking::WithMocha
    extend  Micronaut::ExampleGroupClassMethods

    attr_reader :name, :options, :examples, :before_parts, :after_parts

    def initialize(const_or_name, options={})
      @name, @options = const_or_name.to_s, options
      @examples, @before_parts, @after_parts = [], {:each => [], :all => []}, {:each => [], :all => []}
    end

    def before(type = :each, &block)
      @before_parts[type] << block
    end

    def before_each_parts
      @before_parts[:each]
    end

    def before_all_parts
      @before_parts[:all]
    end

    def after(type = :each, &block)
      @after_parts[type] << block
    end

    def after_each_parts
      @after_parts[:each]
    end

    def after_all_parts
      @after_parts[:all]
    end

    def it(example_description, &example_block)
      @examples << [example_description, example_block]
    end

    def run
      before_all_parts.each { |part| part.call }

      @examples.each do |example_description, example_block| 

        before_each_parts.each { |part| part.call }

        example_block.call

        after_each_parts.each { |part| part.call }

      end

      after_all_parts.each { |part| part.call }
    end
    
    def with_mocks
      yield
      verify_mocks
    end

    def run_group_using(runner)
      result = ''

      begin
        @passed = nil

        setup_mocks
  
        before_all_parts.each { |part| part.call }
        puts "Example Group: #{@name} #{@description}"
        @examples.each do |example_description, example_block| 
          
          puts " - #{example_description}"
          
          before_each_parts.each { |part| with_mocks { part.call } }
          
          if example_block.nil?
            result << 'P'
          else
            with_mocks { example_block.call }
          end
          
          result << '.'
          
          after_each_parts.each { |part| with_mocks { part.call } }
          teardown_mocks
        end
        puts "\n"

        @passed = true
      rescue Exception => e
        result << runner.complain(self, e)
        @passed = false
      ensure
        teardown_mocks
        begin
          after_all_parts.each { |part| part.call }
        rescue Exception => e
          result << runner.complain(self, e)
        end
      end

      result
    end
    
    def describe(name_or_const, &describe_block)
      Kernel.describe(name_or_const, &describe_block)
      puts "nested describe called with args: #{name_or_const}"
    end
    
  end
end