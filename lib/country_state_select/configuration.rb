# frozen_string_literal: true

module CountryStateSelect
  # Global, per-app configuration. Set it from an initializer:
  #
  #   CountryStateSelect.configure do |config|
  #     config.priority_countries = %w[US IN GB]
  #     config.flags = true
  #     config.cache_duration = 1.week
  #   end
  #
  # Every option here is a *default* — the equivalent per-call keyword
  # (e.g. `countries_collection(priority: ...)`) always wins.
  class Configuration
    # Data source answering countries/states/cities lookups. Accepts an
    # object implementing DataSources::Base or a symbol (:city_state).
    attr_accessor :data_source

    # ISO codes listed first in the country dropdown (issue #66).
    attr_accessor :priority_countries

    # Whitelist / blacklist of ISO codes applied to every country lookup.
    attr_accessor :only_countries, :except_countries

    # Prepend the emoji flag to country labels ("🇮🇳 India").
    attr_accessor :flags

    # Append the international dial code to country labels ("India (+91)").
    attr_accessor :dial_codes

    # Translate country names through I18n / the `countries` gem when
    # translations are available. Labels fall back to the English name.
    attr_accessor :localize_names

    # How long the JSON lookup endpoints are HTTP-cached (they serve
    # static data). Set to nil/false to disable cache headers.
    attr_accessor :cache_duration

    # Draw the legacy top-level `/find_states` + `/find_cities` routes in
    # the host app. Disable if you mount the engine at a custom path:
    #
    #   config.draw_routes = false
    #   # config/routes.rb: mount CountryStateSelect::Rails::Engine => '/csc'
    attr_accessor :draw_routes

    def initialize
      @data_source = :city_state
      @priority_countries = []
      @only_countries = nil
      @except_countries = nil
      @flags = false
      @dial_codes = false
      @localize_names = false
      @cache_duration = 86_400 # 1 day, in seconds
      @draw_routes = true
    end

    def data_source_instance
      @data_source_instance ||=
        case data_source
        when :city_state, nil then DataSources::CityState.new
        when Symbol then raise ArgumentError, "Unknown data source: #{data_source.inspect}"
        else data_source
        end
    end

    # Invalidate the memoized adapter when the source changes at runtime
    # (mostly useful in tests).
    def data_source=(source)
      @data_source_instance = nil
      @data_source = source
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      configuration
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
