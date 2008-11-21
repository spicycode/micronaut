require 'micronaut/mocking/with_mocha'
require 'micronaut/exceptions'
require 'micronaut/matchers'
require 'micronaut/expectations'
require 'micronaut/example_world'
require 'micronaut/example_runner'
require 'micronaut/example_group'
require 'micronaut/extensions/kernel'

module Micronaut
  VERSION = "0.0.2"

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

  def self.filter_backtrace(backtrace)
    return ["No backtrace"] unless backtrace

    new_backtrace = []
    backtrace.each_with_index do |line, index|
      break if line.rindex(MICRONAUT_DIR, 0) && index > 2
      new_backtrace << line
    end

    new_backtrace = backtrace.reject { |line| line.rindex(MICRONAUT_DIR, 0) } if new_backtrace.empty?
    new_backtrace = backtrace.dup if new_backtrace.empty?
    new_backtrace
  end
  
end