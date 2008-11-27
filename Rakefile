require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'

GEM = "micronaut"
GEM_VERSION = "0.0.5"
AUTHOR = "Chad Humphries"
EMAIL = "chad@spicycode.com"
HOMEPAGE = "http://spicycode.com"
SUMMARY = "An excellent replacement for the wheel..."

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  # Uncomment this to add a dependency
  s.add_dependency "mocha"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{lib,examples}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

namespace :micronaut do
  
  desc 'Run all examples'
  task :examples do
    examples = Dir["examples/**/*_example.rb"].map { |g| Dir.glob(g) }.flatten
    examples.map! {|f| %Q(require "#{f}")}
    command = "-e '#{examples.join("; ")}'"
    ruby command
  end
  
  desc "Run all examples using rcov"
  task :coverage do
    examples = Dir["examples/**/*_example.rb"].map { |g| Dir.glob(g) }.flatten
    system "rcov --exclude \"examples/*,gems/*,db/*,/Library/Ruby/*,config/*\" --text-report --sort coverage --no-validator-links #{examples.join(' ')}"
  end
  
end

task :default => 'micronaut:coverage'

