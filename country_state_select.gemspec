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
  spec.description   = %q{Can list out country and according to that can list stae.}
  spec.homepage      = "https://github.com/arvindvyas/country_state_select.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 3.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rails', '>= 3.0'
end
