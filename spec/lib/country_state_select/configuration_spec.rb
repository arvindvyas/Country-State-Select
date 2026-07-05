# frozen_string_literal: true

require 'spec_helper'

describe CountryStateSelect::Configuration do
  describe '#data_source_instance' do
    it 'defaults to the CityState adapter' do
      expect(CountryStateSelect.configuration.data_source_instance).to be_a(CountryStateSelect::DataSources::CityState)
    end

    it 'memoizes the instance across calls' do
      config = CountryStateSelect::Configuration.new

      expect(config.data_source_instance).to equal(config.data_source_instance)
    end

    it 'rebuilds the instance when the data source is reassigned' do
      config = CountryStateSelect::Configuration.new
      first = config.data_source_instance

      config.data_source = :city_state
      expect(config.data_source_instance).not_to equal(first)
    end

    it 'raises for an unknown symbol data source' do
      config = CountryStateSelect::Configuration.new
      config.data_source = :not_a_real_source

      expect { config.data_source_instance }.to raise_error(ArgumentError)
    end

    it 'accepts a custom adapter object directly' do
      custom = Class.new(CountryStateSelect::DataSources::Base) do
        def countries = { US: 'United States' }
      end.new
      config = CountryStateSelect::Configuration.new
      config.data_source = custom

      expect(config.data_source_instance).to equal(custom)
    end
  end

  describe 'defaults' do
    it 'has sane defaults for a fresh configuration' do
      config = CountryStateSelect::Configuration.new

      expect(config.priority_countries).to eq([])
      expect(config.flags).to be(false)
      expect(config.dial_codes).to be(false)
      expect(config.localize_names).to be(false)
      expect(config.cache_duration).to eq(86_400)
      expect(config.draw_routes).to be(true)
    end
  end

  describe '.configure' do
    it 'yields the shared configuration and persists changes' do
      CountryStateSelect.configure { |c| c.priority_countries = %w[US] }

      expect(CountryStateSelect.configuration.priority_countries).to eq(%w[US])
    end
  end
end
