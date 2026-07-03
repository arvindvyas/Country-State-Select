# frozen_string_literal: true

module CountryStateSelect
  module DataSources
    # Adapter interface. Implement this to back CountryStateSelect with a
    # different data provider (a database table, the `countries` gem, a
    # remote API, ...) instead of the bundled `city-state` gem — this is
    # what closes out issue #25 (limited/missing city data) without the
    # gem itself owning the data problem.
    class Base
      # @return [Hash{Symbol=>String}] ISO code => English country name
      def countries
        raise NotImplementedError
      end

      # @return [Array<Array(Symbol,String)>] raw [code, name] pairs
      def states(_country_code)
        raise NotImplementedError
      end

      # @return [Array<String>] city names
      def cities(_state_code, _country_code)
        raise NotImplementedError
      end
    end
  end
end
