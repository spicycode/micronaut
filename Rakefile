require 'lib/micronaut/rake_task'

begin 
  require 'jeweler' 
  Jeweler::Tasks.new do |gem| 
    gem.name = "micronaut" 
    gem.executables = "micronaut" 
    gem.summary = "An excellent replacement for the wheel..."
    gem.email = "chad@spicycode.com" 
    gem.homepage = "http://github.com/spicycode/micronaut" 
    gem.description = "An excellent replacement for the wheel..."
    gem.authors = ["Chad Humphries"] 
    gem.files =  FileList["[A-Z]*", "{bin,lib,examples}/**/*"] 
    gem.add_dependency "rspec", ">= 1.2.7"
    gem.add_development_dependency "mocha"
    gem.rubyforge_project = 'spicycode-depot' 
  end 
rescue => e
  puts "Jeweler, or one of its dependencies blew right up. #{e}"
rescue LoadError 
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com" 
end

# These are new tasks
begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do
    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem"]
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end


desc "List files that don't have examples"
task :untested do
  code = Dir["lib/**/*.rb"].map { |g| Dir.glob(g) }.flatten
  examples = Dir["examples/**/*_example.rb"].map { |g| Dir.glob(g) }.flatten
  examples.map! { |f| f =~ /examples\/(.*)_example/; "#{$1}.rb" }
  puts "\nThe following files seem to be missing their examples:"
  (code - examples).each do |missing|
    puts "  #{missing}"
  end
end

puts "Running in Ruby #{RUBY_VERSION}"
desc "Run all micronaut examples"
Micronaut::RakeTask.new :examples do |t|
  t.pattern = "examples/**/*_example.rb"
end

namespace :examples do
  
  desc "Run all micronaut examples using rcov"
  Micronaut::RakeTask.new :coverage do |t|
    t.pattern = "examples/**/*_example.rb"
    t.rcov = true
    t.rcov_opts = %[--exclude "examples/*,gems/*,db/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage]
  end

end

task :default => 'examples:coverage'
