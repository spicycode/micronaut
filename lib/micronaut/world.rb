module Micronaut

  class World
    
    attr_reader :behaviours, :filters
    
    def initialize
      @behaviours = []
      @filters = Micronaut.configuration.filters
    end
    
    def behaviours_to_run
      filter_behaviours
      number_of_behaviours_left = sum_behaviours
      
      if number_of_behaviours_left.zero?
        if filters.empty?
          add_all_examples
        elsif Micronaut.configuration.run_all_when_everything_filtered?
          puts "Filters produced no matches - running everything"
          add_all_examples
        else
          puts "Filters matched no specs - your world is empty, desolate, and alone."
        end
      end
      
      behaviours
    end
    
    def sum_behaviours
      behaviours.inject(0) { |sum, b| sum += b.examples_to_run.size }
    end
    
    def add_all_examples
      behaviours.each do |behaviour|
        behaviour.examples_to_run.concat(behaviour.examples)
      end
    end
    
    def filter_behaviours
      return if filters.size == 0
      
      filters.each do |filter|
        behaviours.each do |behaviour|
          behaviour.examples_to_run.concat find(behaviour.examples, filter)
        end
      end
      behaviours      
    end

    def find(collection, conditions={})
      return [] if conditions.empty?

      collection.select do |item|
        conditions.all? do |key, value|
          case value
          when Hash
            value.all? { |k, v| item.metadata[key][k] == v }
          when Regexp
            item.metadata[key] =~ value
          when Proc
            value.call(item.metadata[key]) rescue false
          else
            item.metadata[key] == value
          end
        end
      end
    end

  end

end