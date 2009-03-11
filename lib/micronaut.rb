require 'micronaut/mocking/with_absolutely_nothing'
require 'micronaut/matchers'
require 'micronaut/expectations'
require 'micronaut/world'
require 'micronaut/configuration'
require 'micronaut/runner'
require 'micronaut/example'
require 'micronaut/behaviour'
require 'micronaut/kernel_extensions'
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
  InstallDirectory = File.expand_path(File.dirname(File.dirname(file)) + "/lib")

  def self.configuration
    @configuration ||= Micronaut::Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
  
  def self.world
    @world ||= Micronaut::World.new
  end
  
end
