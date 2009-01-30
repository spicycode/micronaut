require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'lib/micronaut/rake_task'

GEM = "micronaut"
GEM_VERSION = "0.2.1.6"
AUTHOR = "Chad Humphries"
EMAIL = "chad@spicycode.com"
HOMEPAGE = "http://github.com/spicycode/micronaut"
SUMMARY = "An excellent replacement for the wheel..."

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.markdown", "LICENSE", "RSPEC-LICENSE"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.bindir = 'bin'
  s.default_executable = 'micronaut'
  s.executables = ["micronaut"]
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README.markdown RSPEC-LICENSE Rakefile) + Dir.glob("{lib,examples}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_gemspec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
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

desc "Run all micronaut examples"
Micronaut::RakeTask.new :examples do |t|
  t.pattern = "examples/**/*_example.rb"
end

namespace :examples do
  
  desc "Run all micronaut examples using rcov"
  Micronaut::RakeTask.new :coverage do |t|
    t.pattern = "examples/**/*_example.rb"
    t.rcov = true
    t.rcov_opts = %[--exclude "examples/*,gems/*,db/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage --no-validator-links]
  end

end

task :default => 'examples:coverage'
