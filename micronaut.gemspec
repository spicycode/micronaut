# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{micronaut}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chad Humphries"]
  s.autorequire = %q{micronaut}
  s.date = %q{2008-11-20}
  s.description = %q{An excellent replacement for the wheel...}
  s.email = %q{chad@spicycode.com}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["LICENSE", "README", "Rakefile", "lib/autotest", "lib/autotest/discover.rb", "lib/autotest/micronaut.rb", "lib/micronaut", "lib/micronaut/example_group.rb", "lib/micronaut/example_runner.rb", "lib/micronaut/example_world.rb", "lib/micronaut/expectations", "lib/micronaut/expectations/differs", "lib/micronaut/expectations/differs/default.rb", "lib/micronaut/expectations/handler.rb", "lib/micronaut/expectations/object_extensions.rb", "lib/micronaut/expectations/string_and_symbol_extensions.rb", "lib/micronaut/expectations/wrap_expectation.rb", "lib/micronaut/expectations.rb", "lib/micronaut/extensions", "lib/micronaut/extensions/kernel.rb", "lib/micronaut/matchers", "lib/micronaut/matchers/be.rb", "lib/micronaut/matchers/be_close.rb", "lib/micronaut/matchers/change.rb", "lib/micronaut/matchers/eql.rb", "lib/micronaut/matchers/equal.rb", "lib/micronaut/matchers/errors.rb", "lib/micronaut/matchers/exist.rb", "lib/micronaut/matchers/generated_descriptions.rb", "lib/micronaut/matchers/has.rb", "lib/micronaut/matchers/have.rb", "lib/micronaut/matchers/include.rb", "lib/micronaut/matchers/match.rb", "lib/micronaut/matchers/method_missing.rb", "lib/micronaut/matchers/operator_matcher.rb", "lib/micronaut/matchers/raise_error.rb", "lib/micronaut/matchers/respond_to.rb", "lib/micronaut/matchers/satisfy.rb", "lib/micronaut/matchers/simple_matcher.rb", "lib/micronaut/matchers/throw_symbol.rb", "lib/micronaut/matchers.rb", "lib/micronaut.rb", "examples/example_helper.rb", "examples/lib", "examples/lib/micronaut", "examples/lib/micronaut/example_group_example.rb", "examples/lib/micronaut/example_runner_example.rb", "examples/lib/micronaut/expectations", "examples/lib/micronaut/matchers", "examples/lib/micronaut_example.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://spicycode.com}
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
