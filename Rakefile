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
  end 
  Jeweler::GemcutterTasks.new
rescue LoadError 
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler" 
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

puts "Running in Ruby #{RUBY_PLATFORM} #{RUBY_VERSION}"
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

task :default => [:check_dependencies, :examples]

begin
  %w{sdoc sdoc-helpers rdiscount}.each { |name| gem name }
  require 'sdoc_helpers'
rescue LoadError => ex
  puts "sdoc support not enabled:"
  puts ex.inspect
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "micronaut #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
