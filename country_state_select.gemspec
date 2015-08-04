# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'country_state_select/version'

Gem::Specification.new do |spec|
  spec.name          = "country_state_select"
  spec.version       = CountryStateSelect::VERSION
  spec.authors       = ["Arvind Vyas"]
  spec.email         = ["arvindvyas07@gmail.com"]
  spec.summary       = %q{This is to list country and state.}
  spec.description   = %q{Can list out country and according to that can list state dynamically.}
  spec.homepage      = "https://github.com/arvindvyas/country_state_select.git"
  spec.license       = "MIT"

  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rails', '>= 3.0'
  spec.add_runtime_dependency 'city-state'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
