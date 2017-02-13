$:.unshift File.expand_path('../lib', __FILE__)
require 'model_orchestration/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "model_orchestration"
  s.version     = ModelOrchestration::VERSION
  s.summary     = "A toolkit for orchestrating actions on related models."
  s.description = "In more complex workflows, multiple models that are related to each other need to be created at the same time. This toolkit allows to specifiy models that orchestrate persistence and validation actions of multiple models by nesting them into a so called orchestration model."

  s.required_ruby_version = ">= 2.2.2"

  s.license = "MIT"

  s.author   = "Nils Sommer"
  s.email    = "mail@nilssommer.de"
  s.homepage = "https://github.com/nsommer/model_orchestration"

  s.files        = Dir["MIT-LICENSE", "README.rdoc", "CHANGELOG.md", "lib/**/*"]
  s.require_path = "lib"

  s.extra_rdoc_files = ["README.rdoc"]

  s.add_runtime_dependency "activesupport", '~> 5.0', '>= 5.0.1'
  
  s.add_development_dependency "minitest", '~> 0'
  s.add_development_dependency "activemodel", '~> 5'
  s.add_development_dependency "rake", '~> 0'
  s.add_development_dependency "rdoc", '~> 0'
end