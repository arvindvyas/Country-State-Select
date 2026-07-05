# frozen_string_literal: true

CountryStateSelect.configure do |config|
  # ISO codes shown first in the country dropdown.
  # config.priority_countries = %w[US CA GB]

  # Restrict the country list instead of showing all ~250 countries.
  # config.only_countries = %w[US CA GB IN AU]
  # config.except_countries = %w[KP]

  # Decorate country labels.
  # config.flags = true          # "🇮🇳 India"
  # config.dial_codes = true     # "India (+91)"

  # Translate country names via I18n / the `countries` gem, when available.
  # config.localize_names = true

  # How long the JSON lookup endpoints are HTTP-cached, in seconds.
  # Set to nil to disable caching.
  # config.cache_duration = 1.day

  # Set to false if you want to mount the engine at a custom path instead
  # of the default top-level /find_states, /find_cities routes.
  # config.draw_routes = false

  # Swap in your own data source (a DB table, the `countries` gem, ...) by
  # implementing CountryStateSelect::DataSources::Base and assigning it here.
  # config.data_source = MyApp::CountryDataSource.new
end
