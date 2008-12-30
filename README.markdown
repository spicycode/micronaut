# Micronaut

* Codes: http://github.com/spicycode/micronaut
* Specs: http://runcoderun.com/spicycode/micronaut
* Rails: http://github.com/spicycode/micronaut-rails

## DESCRIPTION:

Micronaut is a light-weight BDD test framework.

## FEATURES:

* API compatible with RSpec (of course)

* Slim and light, designed to be readable, compact, and fast.  Just over ~1600 LOC in /lib at last count.

* Each example has its own metadata, and you can add filters or modules to run/disable/enhance examples based on that metadata at run time
* A Real-world example of the power the metadata gives you:

* "Focused specs".  Never drop out of Autotest again - just focus on the spec(s) and ignore the rest:

		Micronaut.configure do |c| # in your spec_helper
		  c.filter_run :focused => true
		end	

		describe Foo do
			it "autotest will only run this spec, even if your whole suite loads", :focused => true do
			end
			
			# equivalent to:
			focused "is an example_alias to pass in the :focused => true metadata" do
			end
		end
		
* Add your own metadata options and customize Micronaut to your hearts content (pending specs are implemented as ':pending => true' metadata, for example)
		
* Designed to be formatter compatible with RSpec (though this needs some real-world testing)

== REQUIREMENTS:

+ Ruby 1.8

== CREDITS:

* Mini/Unit for the great ideas and runner
* RSpec for the great ideas, matchers, expectations and formatter ideas
* Matchers are licensed under the MIT license, per RSpec (see RSPEC-LICENSE)