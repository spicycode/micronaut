require 'micronaut/mocking/with_mocha'
require 'micronaut/matchers'
require 'micronaut/expectations'
require 'micronaut/world'
require 'micronaut/runner'
require 'micronaut/runner_options'
require 'micronaut/behaviour_group'
require 'micronaut/extensions/kernel'
require 'micronaut/formatters'

module Micronaut
  file = if RUBY_VERSION =~ /^1\.9/ then  # bt's expanded, but __FILE__ isn't :(
           File.expand_path __FILE__
         elsif  __FILE__ =~ /^[^\.]/ then # assume both relative
           require 'pathname'
           pwd = Pathname.new(Dir.pwd)
           path_name = Pathname.new(File.expand_path(__FILE__))
           path_name = File.join(".", path_name.relative_path_from(pwd)) unless path_name.relative?
           path_name.to_s
         else                             # assume both are expanded
           __FILE__
         end

  # './lib' in project dir, or '/usr/local/blahblah' if installed
  MICRONAUT_DIR = File.expand_path(File.dirname(File.dirname(file)))
  
end