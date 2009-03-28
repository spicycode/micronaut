# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{micronaut}
  s.version = "0.2.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chad Humphries"]
  s.date = %q{2009-03-27}
  s.default_executable = %q{micronaut}
  s.description = %q{An excellent replacement for the wheel...}
  s.email = %q{chad@spicycode.com}
  s.executables = ["micronaut"]
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.files = ["History.txt", "LICENSE", "Rakefile", "README.markdown", "RSPEC-LICENSE", "VERSION.yml", "bin/micronaut", "lib/micronaut", "lib/micronaut/behaviour.rb", "lib/micronaut/configuration.rb", "lib/micronaut/example.rb", "lib/micronaut/expectations", "lib/micronaut/expectations/extensions", "lib/micronaut/expectations/extensions/object.rb", "lib/micronaut/expectations/handler.rb", "lib/micronaut/expectations/wrap_expectation.rb", "lib/micronaut/expectations.rb", "lib/micronaut/formatters", "lib/micronaut/formatters/base_formatter.rb", "lib/micronaut/formatters/base_text_formatter.rb", "lib/micronaut/formatters/documentation_formatter.rb", "lib/micronaut/formatters/progress_formatter.rb", "lib/micronaut/formatters.rb", "lib/micronaut/kernel_extensions.rb", "lib/micronaut/matchers", "lib/micronaut/matchers/be.rb", "lib/micronaut/matchers/be_close.rb", "lib/micronaut/matchers/change.rb", "lib/micronaut/matchers/eql.rb", "lib/micronaut/matchers/equal.rb", "lib/micronaut/matchers/generated_descriptions.rb", "lib/micronaut/matchers/has.rb", "lib/micronaut/matchers/have.rb", "lib/micronaut/matchers/include.rb", "lib/micronaut/matchers/match.rb", "lib/micronaut/matchers/method_missing.rb", "lib/micronaut/matchers/operator_matcher.rb", "lib/micronaut/matchers/raise_error.rb", "lib/micronaut/matchers/respond_to.rb", "lib/micronaut/matchers/satisfy.rb", "lib/micronaut/matchers/simple_matcher.rb", "lib/micronaut/matchers/throw_symbol.rb", "lib/micronaut/matchers.rb", "lib/micronaut/mocking", "lib/micronaut/mocking/with_absolutely_nothing.rb", "lib/micronaut/mocking/with_mocha.rb", "lib/micronaut/mocking/with_rr.rb", "lib/micronaut/rake_task.rb", "lib/micronaut/runner.rb", "lib/micronaut/world.rb", "lib/micronaut.rb", "examples/example_helper.rb", "examples/lib", "examples/lib/micronaut", "examples/lib/micronaut/behaviour_example.rb", "examples/lib/micronaut/configuration_example.rb", "examples/lib/micronaut/example_example.rb", "examples/lib/micronaut/expectations", "examples/lib/micronaut/expectations/extensions", "examples/lib/micronaut/expectations/extensions/object_example.rb", "examples/lib/micronaut/expectations/fail_with_example.rb", "examples/lib/micronaut/expectations/wrap_expectation_example.rb", "examples/lib/micronaut/formatters", "examples/lib/micronaut/formatters/base_formatter_example.rb", "examples/lib/micronaut/formatters/documentation_formatter_example.rb", "examples/lib/micronaut/formatters/progress_formatter_example.rb", "examples/lib/micronaut/kernel_extensions_example.rb", "examples/lib/micronaut/matchers", "examples/lib/micronaut/matchers/be_close_example.rb", "examples/lib/micronaut/matchers/be_example.rb", "examples/lib/micronaut/matchers/change_example.rb", "examples/lib/micronaut/matchers/description_generation_example.rb", "examples/lib/micronaut/matchers/eql_example.rb", "examples/lib/micronaut/matchers/equal_example.rb", "examples/lib/micronaut/matchers/has_example.rb", "examples/lib/micronaut/matchers/have_example.rb", "examples/lib/micronaut/matchers/include_example.rb", "examples/lib/micronaut/matchers/match_example.rb", "examples/lib/micronaut/matchers/matcher_methods_example.rb", "examples/lib/micronaut/matchers/operator_matcher_example.rb", "examples/lib/micronaut/matchers/raise_error_example.rb", "examples/lib/micronaut/matchers/respond_to_example.rb", "examples/lib/micronaut/matchers/satisfy_example.rb", "examples/lib/micronaut/matchers/simple_matcher_example.rb", "examples/lib/micronaut/matchers/throw_symbol_example.rb", "examples/lib/micronaut/mocha_example.rb", "examples/lib/micronaut/runner_example.rb", "examples/lib/micronaut/world_example.rb", "examples/lib/micronaut_example.rb", "examples/resources", "examples/resources/example_classes.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/spicycode/micronaut}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{An excellent replacement for the wheel...}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
