# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/dynamo/version'

Gem::Specification.new do |spec|
  spec.name          = 'rom-dynamo'
  spec.version       = ROM::Dynamo::VERSION
  spec.authors       = ['Michael Rykov', 'David Kelley']
  spec.email         = ['mrykov@gmail.com', 'david@stockflare.com']

  spec.summary       = 'DynamoDB adapter for Ruby Object Mapper'
  spec.description   = 'DynamoDB adapter for Ruby Object Mapper'
  spec.homepage      = 'https://github.com/Stockflare/rom-dynamo'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = Gem::Requirement.new('>= 2.0.0')

  spec.add_runtime_dependency 'rom', '~> 1.0.0'
  spec.add_runtime_dependency 'aws-sdk-core', '~> 2.1'
  spec.add_runtime_dependency 'activesupport', '>= 4.0'

  spec.add_development_dependency 'bundler', ['~> 1.7']
  spec.add_development_dependency 'rake', ['~> 10.3']
  spec.add_development_dependency 'rspec', ['~> 3.0']
  spec.add_development_dependency 'faker', ['~> 1.4']
  spec.add_development_dependency 'yard', ['~> 0.8']
  spec.add_development_dependency 'dotenv', ['~> 2.0']
  spec.add_development_dependency 'rubocop', ['~> 0.32']
  spec.add_development_dependency 'factory_girl', ['~> 4.5']
end
