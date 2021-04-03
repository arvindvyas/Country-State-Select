# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'country_state_select/version'

Gem::Specification.new do |spec|
  spec.name          = 'country_state_select'
  spec.version       = CountryStateSelect::VERSION
  spec.authors       = ['Arvind Vyas']
  spec.email         = ['arvindvyas07@gmail.com']
  spec.summary       = 'Dynamically select Country and State.'
  spec.description   = 'Country State Select is a Ruby Gem that aims to make Country and State/Province selection a cinch in Ruby on Rails environments.'
  spec.homepage      = 'https://github.com/arvindvyas/Country-State-Select'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec'

  spec.add_runtime_dependency 'city-state'
  spec.add_runtime_dependency 'rails'
end
