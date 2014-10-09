# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'permission_policy/version'

Gem::Specification.new do |spec|
  spec.name          = 'permission_policy'
  spec.version       = PermissionPolicy::VERSION
  spec.authors       = ['Marco Schaden', 'Maximilian Schulz']
  spec.email         = ['marco@railslove.com', 'max@railslove.com']
  spec.summary       = 'Without order, there is chaos'
  spec.description   = 'Expandable object oriented authorization solution for Ruby/Rails applications'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rspec', '~> 3.0.0'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
end
