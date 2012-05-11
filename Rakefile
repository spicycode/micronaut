require "bundler"
Bundler::GemHelper.install_tasks

require 'micronaut/rake_task'

desc "Run all micronaut examples"
Micronaut::RakeTask.new(:examples) 

task :default => :examples
