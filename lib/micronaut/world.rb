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
      Micronaut.configuration.filters.each do |filter|
        behaviours.each do |behaviour|
          behaviour.examples_to_run.concat find(behaviour.examples, filter)
        end
      end
      behaviours
    end

    def self.find(collection=behaviours, conditions={})
      return collection if conditions.empty?

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