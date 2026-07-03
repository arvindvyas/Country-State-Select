# frozen_string_literal: true

module CountryStateSelect
  # Best-effort translation of country names for the current I18n.locale.
  #
  # Two lookup strategies, tried in order, so neither is a hard dependency:
  #
  #   1. The `countries` gem (ISO3166::Country), if the host app already
  #      depends on it — it ships translations for all ISO locales.
  #   2. A `country_state_select.countries.<ISO_CODE>` key in the host
  #      app's own locale files, for apps that want to supply their own.
  #
  # Falls back to the English name from the data source when neither
  # strategy has a translation, so `localize_names` is always safe to turn
  # on even with sparse translation coverage.
  module Localization
    module_function

    def country_name(code, english_name)
      return english_name unless CountryStateSelect.configuration.localize_names

      via_countries_gem(code) || via_i18n(code) || english_name
    end

    def via_countries_gem(code)
      return nil unless defined?(::ISO3166::Country)

      ::ISO3166::Country.new(code.to_s)&.translations&.[](I18n.locale.to_s)
    rescue StandardError
      nil
    end

    def via_i18n(code)
      key = "country_state_select.countries.#{code}"
      translated = I18n.t(key, default: nil)
      translated if translated.present?
    rescue StandardError
      nil
    end
  end
end
