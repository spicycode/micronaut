# Micronaut

* [Codes - http://github.com/spicycode/micronaut](http://github.com/spicycode/micronaut)
* [Examples - http://runcoderun.com/spicycode/micronaut](http://runcoderun.com/spicycode/micronaut)
* [Rails - http://github.com/spicycode/micronaut-rails](http://github.com/spicycode/micronaut-rails)

## DESCRIPTION:

Micronaut is a light-weight BDD test framework.

## FEATURES:

* API compatible with RSpec (of course)

* Slim and light, designed to be readable, compact, and fast.  Just over ~1600 LOC in /lib at last count.

* Each example has its own metadata, and you can add filters or modules to run/disable/enhance examples based on that metadata at run time
* A Real-world example of the power the metadata gives you:

* "Focused examples".  Never drop out of Autotest again - just focus on the example(s) and ignore the rest:

		Micronaut.configure do |c| # in your example_helper
		  c.filter_run :focused => true
		end	

		describe Foo do
			it "this example will run", :focused => true do
			end
			
			# equivalent to:
			focused "so will this one (this is an alias for :focused => true)" do
			end
			
			it "this example will not run, until the focused ones are removed" do
			end
		end
		
* Add your own metadata options and customize Micronaut to your hearts content (pending specs are implemented as ':pending => true' metadata, for example)
		
* Designed to be formatter compatible with RSpec (though this needs some real-world testing)

* Rake task for simple setup
  
   require 'rubygems'
   require 'micronaut/rake_task'

   desc "Run all micronaut examples"
   Micronaut::RakeTask.new :examples do |t|
     t.pattern = "examples/**/*_example.rb"
   end

   desc "Run all micronaut examples using rcov"
   Micronaut::RakeTask.new :coverage do |t|
     t.pattern = "examples/**/*_example.rb"
     t.rcov = true
     t.rcov_opts = "--exclude \"examples/*,gems/*,db/*,/Library/Ruby/*,config/*\" --text-summary  --sort coverage --no-validator-links" 
   end
## REQUIREMENTS:

+ Ruby 1.8.6+

## CREDITS:

* Mini/Unit for the great ideas and runner
* RSpec for the great ideas, matchers, expectations and formatter ideas
* Matchers are licensed under the MIT license, per RSpec (see RSPEC-LICENSE)
