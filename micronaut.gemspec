# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{micronaut}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chad Humphries"]
  s.autorequire = %q{micronaut}
  s.date = %q{2008-12-08}
  s.description = %q{An excellent replacement for the wheel...}
  s.email = %q{chad@spicycode.com}
  s.extra_rdoc_files = ["README", "LICENSE", "RSPEC-LICENSE"]
  s.files = ["LICENSE", "README", "RSPEC-LICENSE", "Rakefile", "lib/autotest", "lib/autotest/discover.rb", "lib/autotest/micronaut.rb", "lib/micronaut", "lib/micronaut/behaviour.rb", "lib/micronaut/configuration.rb", "lib/micronaut/example.rb", "lib/micronaut/expectations", "lib/micronaut/expectations/errors.rb", "lib/micronaut/expectations/extensions", "lib/micronaut/expectations/extensions/object.rb", "lib/micronaut/expectations/extensions/string_and_symbol.rb", "lib/micronaut/expectations/extensions.rb", "lib/micronaut/expectations/handler.rb", "lib/micronaut/expectations/wrap_expectation.rb", "lib/micronaut/expectations.rb", "lib/micronaut/formatters", "lib/micronaut/formatters/base_formatter.rb", "lib/micronaut/formatters/base_text_formatter.rb", "lib/micronaut/formatters/documentation_formatter.rb", "lib/micronaut/formatters/progress_formatter.rb", "lib/micronaut/formatters.rb", "lib/micronaut/kernel_extensions.rb", "lib/micronaut/matchers", "lib/micronaut/matchers/be.rb", "lib/micronaut/matchers/be_close.rb", "lib/micronaut/matchers/change.rb", "lib/micronaut/matchers/eql.rb", "lib/micronaut/matchers/equal.rb", "lib/micronaut/matchers/generated_descriptions.rb", "lib/micronaut/matchers/has.rb", "lib/micronaut/matchers/have.rb", "lib/micronaut/matchers/include.rb", "lib/micronaut/matchers/match.rb", "lib/micronaut/matchers/method_missing.rb", "lib/micronaut/matchers/operator_matcher.rb", "lib/micronaut/matchers/raise_error.rb", "lib/micronaut/matchers/respond_to.rb", "lib/micronaut/matchers/satisfy.rb", "lib/micronaut/matchers/simple_matcher.rb", "lib/micronaut/matchers/throw_symbol.rb", "lib/micronaut/matchers.rb", "lib/micronaut/mocking", "lib/micronaut/mocking/with_absolutely_nothing.rb", "lib/micronaut/mocking/with_mocha.rb", "lib/micronaut/mocking.rb", "lib/micronaut/runner.rb", "lib/micronaut/runner_options.rb", "lib/micronaut/world.rb", "lib/micronaut.rb", "examples/example_helper.rb", "examples/lib", "examples/lib/micronaut", "examples/lib/micronaut/behaviour_example.rb", "examples/lib/micronaut/configuration_example.rb", "examples/lib/micronaut/example_example.rb", "examples/lib/micronaut/expectations", "examples/lib/micronaut/expectations/extensions", "examples/lib/micronaut/expectations/extensions/object_example.rb", "examples/lib/micronaut/expectations/fail_with_example.rb", "examples/lib/micronaut/expectations/wrap_expectation_example.rb", "examples/lib/micronaut/formatters", "examples/lib/micronaut/formatters/base_formatter_example.rb", "examples/lib/micronaut/formatters/documentation_formatter_example.rb", "examples/lib/micronaut/formatters/progress_formatter_example.rb", "examples/lib/micronaut/kernel_extensions_example.rb", "examples/lib/micronaut/matchers", "examples/lib/micronaut/matchers/be_close_example.rb", "examples/lib/micronaut/matchers/be_example.rb", "examples/lib/micronaut/matchers/change_example.rb", "examples/lib/micronaut/matchers/description_generation_example.rb", "examples/lib/micronaut/matchers/eql_example.rb", "examples/lib/micronaut/matchers/equal_example.rb", "examples/lib/micronaut/matchers/handler_example.rb", "examples/lib/micronaut/matchers/has_example.rb", "examples/lib/micronaut/matchers/have_example.rb", "examples/lib/micronaut/matchers/include_example.rb", "examples/lib/micronaut/matchers/match_example.rb", "examples/lib/micronaut/matchers/matcher_methods_example.rb", "examples/lib/micronaut/matchers/operator_matcher_example.rb", "examples/lib/micronaut/matchers/raise_error_example.rb", "examples/lib/micronaut/matchers/respond_to_example.rb", "examples/lib/micronaut/matchers/satisfy_example.rb", "examples/lib/micronaut/matchers/simple_matcher_example.rb", "examples/lib/micronaut/matchers/throw_symbol_example.rb", "examples/lib/micronaut/runner_example.rb", "examples/lib/micronaut/runner_options_example.rb", "examples/lib/micronaut/world_example.rb", "examples/lib/micronaut_example.rb", "examples/resources", "examples/resources/example_classes.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://spicycode.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{An excellent replacement for the wheel...}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
