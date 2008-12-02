module Micronaut

  class World
  
    def self.reset
      @behaviour_groups = []
    end

    reset
  
    def self.behaviour_groups
      @behaviour_groups
    end
    
    def self.find(conditions={})
      return [] if conditions.empty?
      
      behaviour_groups.select do |group|
        conditions.all? do |key, value|
          case value
          when Hash
            value.all? { |k, v| group.metadata[key][k] == v }
          else
            group.metadata[key] == value
          end
        end
      end
    end
  
  end
  
end