require 'autotest'

Autotest.add_hook :initialize do |at|
  at.clear_mappings
  # watch out: Ruby bug (1.8.6):
  # %r(/) != /\//
  at.add_mapping(%r%^examples/.*_example.rb$%) { |filename, _| 
    filename 
  }
  at.add_mapping(%r%^lib/(.*)\.rb$%) { |filename, m| 
    ["examples/lib/#{m[1]}_example.rb"]
  }
  at.add_mapping(%r%^examples/(example_helper|shared/.*)\.rb$%) { 
    at.files_matching %r%^examples/.*_example\.rb$%
  }
end

class MicronautCommandError < StandardError; end

class Autotest::Micronaut < Autotest

  def initialize
    super
    self.failed_results_re = /^\d+\)\n(?:\e\[\d*m)?(?:.*?Error in )?'([^\n]*)'(?: FAILED)?(?:\e\[\d*m)?\n(.*?)\n\n/m
    self.completed_re = /\n(?:\e\[\d*m)?\d* examples?/m
  end
  
  def consolidate_failures(failed)
    filters = new_hash_of_arrays
    failed.each do |spec, trace|
      if trace =~ /\n(\.\/)?(.*example\.rb):[\d]+:\Z?/
        filters[$2] << spec
      end
    end
    return filters
  end

  def make_test_cmd(files_to_test)
    return '' if files_to_test.empty?
    
    examples = files_to_test.keys.flatten
    
    examples.map! {|f| %Q(require "#{f}")}

    return "#{ruby} -e '#{examples.join("; ")}'"
  end
  
end
