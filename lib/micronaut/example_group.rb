module Micronaut
  class ExampleGroup
    include Micronaut::Matchers
    include Micronaut::Mocking::WithMocha

    attr_reader :name, :description, :examples, :before_parts, :after_parts

    def initialize(const_or_name, description=nil)
      @name, @description = const_or_name.to_s, description
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

    def run_group_using(runner)
      result = ''

      begin
        @passed = nil

        before_all_parts.each { |part| part.call }

        @examples.each do |example_description, example_block| 

          setup_mocks

          before_each_parts.each { |part| part.call }

          if example_block.nil?
            result << 'P'
          else
            example_block.call
          end

          result << '.'

          after_each_parts.each { |part| part.call }

          verify_mocks

          teardown_mocks
        end

        @passed = true
      rescue Exception => e
        result << runner.complain(self.class, self.name, e)
        @passed = false
      ensure
        begin
          after_all_parts.each { |part| part.call }
        rescue Exception => e
          result << runner.complain(self.class, self.name, e)
        end
      end

      result
    end

  end
end