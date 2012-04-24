require "bundler"
Bundler::GemHelper.install_tasks

require 'micronaut/rake_task'

puts "Running in Ruby #{RUBY_PLATFORM} #{RUBY_VERSION}"
desc "Run all micronaut examples"
Micronaut::RakeTask.new(:examples) 

task :default => :examples
