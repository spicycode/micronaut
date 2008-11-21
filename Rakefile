require 'rubygems'
require 'rake'

desc "Run all examples"
task :default do
  examples = Dir["examples/**/*_example.rb"].map { |g| Dir.glob(g) }.flatten
  examples.map! {|f| %Q(require "#{f}")}
  command = "-e '#{examples.join("; ")}'"
  ruby command
end