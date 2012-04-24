#!/usr/bin/env ruby

require 'rake'
require 'rake/tasklib'

module Micronaut

  class RakeTask < ::Rake::TaskLib

    # Name of task. (default is :spec)
    attr_accessor :name

    # If true, requests that the specs be run with the warning flag set.
    # E.g. warning=true implies "ruby -w" used to run the specs. Defaults to false.
    attr_accessor :warning

    # Glob pattern to match example files. (default is 'spec/**/*_spec.rb')
    attr_accessor :pattern

    # Array of commandline options to pass to ruby. Defaults to [].
    attr_accessor :ruby_opts

    # Whether or not to fail Rake when an error occurs (typically when spec fail).
    # Defaults to true.
    attr_accessor :fail_on_error

    # A message to print to stderr when there are failures.
    attr_accessor :failure_message

    # Use verbose output. If this is set to true, the task will print
    # the executed spec command to stdout. Defaults to false.
    attr_accessor :verbose

    def initialize(*args)
      @name = args.shift || :spec
      @pattern = nil
      @warning = false
      @ruby_opts = []
      @fail_on_error = true

      yield self if block_given?
      @pattern ||= 'spec/**/*_spec.rb'
      define
    end

    def define # :nodoc:
      actual_name = Hash === name ? name.keys.first : name
      desc("Run all spec") unless ::Rake.application.last_comment

      task name do
        RakeFileUtils.send(:verbose, verbose) do
          if specs_to_run.empty?
            puts "No spec matching #{pattern} could be found"
          else
            cmd_parts = [RUBY]
            cmd_parts += ruby_opts
            cmd_parts << "-Ispec:lib"
            cmd_parts << "-w" if warning
            cmd_parts += specs_to_run.collect { |fn| %["#{fn}"] }
            cmd = cmd_parts.join(" ")
            puts cmd if verbose
            unless system(cmd)
              STDERR.puts failure_message if failure_message
              raise("Command #{cmd} failed") if fail_on_error
            end
          end
        end
      end

      self
    end

    def specs_to_run # :nodoc:
      Dir[pattern].map { |filename| File.expand_path(filename) }
    end

  end

end
