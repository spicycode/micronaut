require 'micronaut/mocking/with_absolutely_nothing'
require 'micronaut/expectations'
require 'micronaut/world'
require 'micronaut/configuration'
require 'micronaut/runner'
require 'micronaut/example'
require 'micronaut/behaviour'
require 'micronaut/kernel_extensions'
require 'micronaut/formatters'

module Micronaut
  InstallDirectory = File.expand_path(File.dirname(File.dirname(File.expand_path(__FILE__))) + "/lib")

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
