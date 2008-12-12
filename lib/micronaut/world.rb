module Micronaut

  class World

    def self.reset
      @behaviours = []
    end

    reset

    def self.behaviours
      @behaviours
    end

    def self.examples_to_run(behaviour)

    end

    def self.behaviours_to_run
      behaviours.each do |behaviour|
        Micronaut.configuration.filters.each do |filter|
          behaviour.examples_to_run.concat find(behaviour.examples, filter)
        end
      end
      
      if behaviours.inject(0) { |sum, b| sum += b.examples_to_run.size }.zero? 
        puts "No behaviours found at all anywhere"
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