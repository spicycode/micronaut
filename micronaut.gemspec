# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "micronaut/version"

Gem::Specification.new do |s|
  s.name = 'micronaut'
  s.version = Micronaut::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors = ["Chad Humphries"]
  s.date = %q{2009-08-10}
  s.default_executable = %q{micronaut}
  s.description = %q{An excellent replacement for the wheel...}
  s.email = %q{chad@spicycode.com}
  s.executables = ["micronaut"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files            = `git ls-files -- lib/*`.split("\n")
  s.files           += %w[README.markdown LICENSE RSPEC-LICENSE]
  s.homepage = %q{http://github.com/spicycode/micronaut}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{spicycode-depot}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{An excellent replacement for the wheel...}
  s.test_files       = `git ls-files -- spec/*`.split("\n")

  # s.add_development_dependency "cucumber", "~> 1.1.9"
  # s.add_development_dependency "aruba",    "~> 0.4.11"
  # s.add_development_dependency "ZenTest",  "4.6.2"
  # s.add_development_dependency "nokogiri", "1.5.2"
  # s.add_development_dependency "fakefs",   "0.4.0"
  # s.add_development_dependency "syntax",   "1.0.0"

  s.add_development_dependency "mocha",    "~> 0.10.5"
  # s.add_development_dependency "rr",       "~> 1.0.4"
  # s.add_development_dependency "flexmock", "~> 0.9.0"
end
