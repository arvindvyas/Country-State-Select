# frozen_string_literal: true

require 'spec_helper'

describe 'CountryStateSelect only/except/priority filtering' do
  after { CountryStateSelect.reset_configuration! }

  describe '.countries_collection' do
    it 'restricts to only the given codes when passed explicitly' do
      result = CountryStateSelect.countries_collection(only: %w[US IN])

      expect(result.map(&:last)).to contain_exactly(:US, :IN)
    end

    it 'excludes the given codes when passed explicitly' do
      result = CountryStateSelect.countries_collection(except: %w[US])

      expect(result.map(&:last)).not_to include(:US)
    end

    it 'moves priority codes to the front, in the given order' do
      result = CountryStateSelect.countries_collection(priority: %w[IN US])

      expect(result.first(2).map(&:last)).to eq(%i[IN US])
    end

    it 'reads only/except/priority from global configuration when not passed explicitly' do
      CountryStateSelect.configure do |c|
        c.only_countries = %w[US IN GB]
        c.priority_countries = %w[GB]
      end

      result = CountryStateSelect.countries_collection

      expect(result.first.last).to eq(:GB)
      expect(result.map(&:last)).to contain_exactly(:US, :IN, :GB)
    end

    it 'lets a per-call override win over global configuration' do
      CountryStateSelect.configure { |c| c.only_countries = %w[US] }

      result = CountryStateSelect.countries_collection(only: %w[IN])

      expect(result.map(&:last)).to contain_exactly(:IN)
    end
  end

  describe '.collect_states / .raw_states' do
    it 'returns [name, code] pairs from collect_states and [code, name] from raw_states' do
      labeled = CountryStateSelect.collect_states('US')
      raw = CountryStateSelect.raw_states('US')

      expect(labeled.first).to eq(raw.first.reverse)
    end

    it 'applies only/except/priority the same way as countries' do
      result = CountryStateSelect.collect_states('US', only: %w[CA NY])

      expect(result.map(&:last)).to contain_exactly(:CA, :NY)
    end
  end

  describe '.countries_except' do
    it 'is equivalent to countries_collection(except: ...)' do
      expect(CountryStateSelect.countries_except('US')).to eq(CountryStateSelect.countries_collection(except: ['US']))
    end
  end
end
