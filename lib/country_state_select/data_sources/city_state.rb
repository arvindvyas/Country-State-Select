# frozen_string_literal: true

require 'city-state'

module CountryStateSelect
  module DataSources
    # Default adapter, backed by the `city-state` gem (unchanged behavior
    # from 3.x). `CS.countries` returns a Hash memoized for the whole
    # process, so every read here is non-mutating.
    class CityState < Base
      def countries
        CS.countries.reject { |k, _| k == :COUNTRY_ISO_CODE }
      end

      def states(country_code)
        return [] if country_code.nil? || country_code.to_s.empty?

        (CS.states(country_code) || {}).to_a
      end

      def cities(state_code, country_code)
        return [] if state_code.nil? || state_code.to_s.empty?

        CS.cities(state_code.to_sym, country_code.to_s.empty? ? nil : country_code.to_sym) || []
      end
    end
  end
end
