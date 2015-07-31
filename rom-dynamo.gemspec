# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/dynamo/version'

Gem::Specification.new do |spec|
  spec.name          = 'rom-dynamo'
  spec.version       = Rom::Dynamo::VERSION
  spec.authors       = ['Michael Rykov', 'David Kelley']
  spec.email         = ['mrykov@gmail.com', 'david@stockflare.com']

  spec.summary       = %q{DynamoDB adapter for Ruby Object Mapper}
  spec.description   = %q{DynamoDB adapter for Ruby Object Mapper}
  spec.homepage      = 'https://github.com/Stockflare/rom-dynamo'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = Gem::Requirement.new(">= 2.0.0")

  spec.add_runtime_dependency %q<rom>, '~> 0.8'
  spec.add_runtime_dependency %q<aws-sdk-core>, '~> 2.1'

  spec.add_development_dependency %q<bundler>, ['~> 1.7']
  spec.add_development_dependency %q<rake>, ['~> 10.3']
  spec.add_development_dependency %q<rspec>, ['~> 3.0']
  spec.add_development_dependency %q<faker>, ['~> 1.4']
  spec.add_development_dependency %q<yard>, ['~> 0.8']
  spec.add_development_dependency %q<dotenv>, ['~> 2.0']
  spec.add_development_dependency %q<rubocop>, ['~> 0.32']
end
