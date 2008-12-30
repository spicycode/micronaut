module Micronaut

  class World

    attr_reader :behaviours

    def initialize
      @behaviours = []
    end
    
    def filter
      Micronaut.configuration.filter
    end

    def behaviours_to_run
      return @behaviours_to_run if @behaviours_to_run
      
      if filter
        @behaviours_to_run = filter_behaviours
        if @behaviours_to_run.size == 0 && Micronaut.configuration.run_all_when_everything_filtered?
          puts "No behaviours were matched by #{filter.inspect}, running all"
          # reset the behaviour list to all behaviours, and add back all examples
          @behaviours_to_run = @behaviours
          @behaviours.each { |b| b.examples_to_run.replace(b.examples) }
        else
          Micronaut.configuration.output.puts "Run filtered using #{filter.inspect}"          
        end
      else
        @behaviours_to_run = @behaviours
        @behaviours.each { |b| b.examples_to_run.replace(b.examples) }
      end      

      @behaviours_to_run
    end

    def total_examples_to_run
      @total_examples_to_run ||= behaviours_to_run.inject(0) { |sum, b| sum += b.examples_to_run.size }
    end

    def filter_behaviours
      behaviours.inject([]) do |list, b|
        b.examples_to_run.replace(find(b.examples, filter).uniq)
        # Do not add behaviours with 0 examples to run
        list << (b.examples_to_run.size == 0 ? nil : b)
      end.compact
    end

    def find(collection, conditions={})
      collection.select do |item|
        conditions.all? { |filter_on, filter| apply_condition(filter_on, filter, item.metadata) }
      end
    end
    
    def find_behaviours(conditions={})
      find(behaviours, conditions)
    end

    def apply_condition(filter_on, filter, metadata)
      return false if metadata.nil?

      case filter
      when Hash
        filter.all? { |k, v| apply_condition(k, v, metadata[filter_on]) }
      when Regexp
        metadata[filter_on] =~ filter
      when Proc
        filter.call(metadata[filter_on]) rescue false
      else
        metadata[filter_on] == filter
      end
    end

  end

end