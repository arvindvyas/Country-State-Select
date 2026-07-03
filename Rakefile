# frozen_string_literal: true

require 'bundler/gem_tasks'

namespace :js do
  desc 'Compile app/javascript/country_state_select/country_state_select.js into the ' \
       'Sprockets-loadable vendor/assets/javascript/country_state_select_vanilla.js build'
  task :build do
    source_path = File.expand_path('app/javascript/country_state_select/country_state_select.js', __dir__)
    dest_path = File.expand_path('vendor/assets/javascript/country_state_select_vanilla.js', __dir__)

    source = File.read(source_path)
    body = source.sub('export default function CountryStateSelect(options) {', 'function CountryStateSelect(options) {')
    raise "Could not find the expected export in #{source_path} — did the function signature change?" if body == source

    File.write(dest_path, <<~JS)
      // GENERATED FILE — do not edit directly.
      // Source: app/javascript/country_state_select/country_state_select.js
      // Regenerate with `rake js:build` after editing the source.
      (function (global) {
      #{body.gsub(/^/, '  ').rstrip}

        global.CountryStateSelect = CountryStateSelect;
      })(this);
    JS

    puts "Wrote #{dest_path}"
  end
end
