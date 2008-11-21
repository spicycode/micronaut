class Micronaut::ExampleWorld
  
  def self.reset
    @@example_groups = []
  end

  reset
  
  def self.example_groups
    @@example_groups
  end
  
end