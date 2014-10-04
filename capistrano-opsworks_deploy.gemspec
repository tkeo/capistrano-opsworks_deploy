# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/opsworks_deploy/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-opsworks_deploy"
  spec.version       = Capistrano::OpsworksDeploy::VERSION
  spec.authors       = ["Takeo Fujita"]
  spec.email         = ["takeofujita@gmail.com"]
  spec.summary       = %q{deploy application using OpsWorks API}
  spec.homepage      = "https://github.com/tkeo/capistrano-opsworks_deploy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "capistrano", "~> 3.0"
  spec.add_runtime_dependency "aws-sdk-core", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
