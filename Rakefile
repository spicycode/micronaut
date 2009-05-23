require 'lib/micronaut/rake_task'

begin 
  require 'jeweler' 
  Jeweler::Tasks.new do |s| 
    s.name = "micronaut" 
    s.executables = "micronaut" 
    s.summary = "An excellent replacement for the wheel..."
    s.email = "chad@spicycode.com" 
    s.homepage = "http://github.com/spicycode/micronaut" 
    s.description = "An excellent replacement for the wheel..."
    s.authors = ["Chad Humphries"] 
    s.files =  FileList["[A-Z]*", "{bin,lib,examples}/**/*"] 
    s.rubyforge_project = 'spicycode-depot' 
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
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/the-perfect-gem/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
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
