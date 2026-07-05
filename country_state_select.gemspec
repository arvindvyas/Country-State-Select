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
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.start_with?('spec/dummy/') }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'importmap-rails'
  spec.add_development_dependency 'propshaft'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'stimulus-rails'

  spec.add_runtime_dependency 'city-state'
  spec.add_runtime_dependency 'rails', '>= 7.0'
end
