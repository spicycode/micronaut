module Micronaut

  class World

    def self.reset
      @behaviours = []
    end

    reset

    def self.behaviours
      @behaviours
    end

    def self.behaviours_to_run
      filter_behaviours
      number_of_behaviours_left = sum_behaviours
      
      if number_of_behaviours_left.zero?
        if Micronaut.configuration.filters.empty?
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
    
    def self.sum_behaviours
      behaviours.inject(0) { |sum, b| sum += b.examples_to_run.size }
    end
    
    def self.add_all_examples
      behaviours.each do |behaviour|
        behaviour.examples_to_run.concat(behaviour.examples)
      end
    end
    
    def self.filter_behaviours
      return unless Micronaut.configuration.filters.any?
      Micronaut.configuration.filters.each do |filter|
        behaviours.each do |behaviour|
          behaviour.examples_to_run.concat find(behaviour.examples, filter)
        end
      end
      behaviours      
    end

    def self.find(collection, conditions={})
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