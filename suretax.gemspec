# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "suretax/version"

Gem::Specification.new do |spec|
  spec.name          = "suretax"
  spec.version       = Suretax::VERSION
  spec.authors       = ["Damon Davison", "Raymond Gan"]
  spec.email         = ["damon@allolex.net", "rayning@yahoo.com"]
  spec.description   = "A wrapper library for the SureTax communications tax API, customized for XBP."
  spec.summary       = "This gem will allow Ruby developers to easily integrate SureTax into their apps."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "excon"
  spec.add_dependency "money", "~> 6.9.0"
  spec.add_dependency "monetize"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "rspec-its", "~> 1.0"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "webmock"
end
