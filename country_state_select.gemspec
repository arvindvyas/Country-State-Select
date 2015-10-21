# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'country_state_select/version'

Gem::Specification.new do |spec|
  spec.name          = "country_state_select"
  spec.version       = CountryStateSelect::VERSION
  spec.authors       = ["Arvind Vyas", "Adam De Fouw"]
  spec.email         = ["arvindvyas07@gmail.com", "aldefouw@medicine.wisc.edu"]
  spec.summary       = %q{Dynamically select country and state.}
  spec.description   = %q{Country Region Select is a Ruby Gem that aims to make Country and State/Province selection a cinch in Ruby on Rails environments.}
  spec.homepage      = "https://github.com/aldefouw/country_state_select.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'rails'
  spec.add_runtime_dependency 'simple_form', "~> 3.2"
  spec.add_runtime_dependency 'chosen-rails', "~> 1.4"
  spec.add_runtime_dependency 'compass-rails', '~> 2.0.4'
  spec.add_runtime_dependency 'city-state'
end
