# frozen_string_literal: true

require 'spec_helper'

describe CountryStateSelect do
  describe '#countries_collection' do
    it 'does not include :COUNTRY_ISO_CODE' do
      expect(CountryStateSelect.countries_collection).not_to include([COUNTRY_ISO_CODE: 'country_name'])
    end

    it 'returns an array' do
      method_call = CountryStateSelect.countries_collection
      expect(method_call.class).to eq(Array)
    end

    it 'returns the value first and the key second' do
      method_call = CountryStateSelect.countries_collection
      expect(method_call[0][0]).to eq('Andorra')
      expect(method_call[0][1]).to eq(:AD)
    end
  end

  describe '#countries_except' do
    let(:us) { ['United States', :US] }
    let(:sm) { ['Saint Martin', :MF] }
    let(:exceptions) { [us, sm] }

    it 'does include the United States ordinarily' do
      expect(CountryStateSelect.countries_except([])).to include(us)
    end

    it 'does include Saint Martin ordinarily' do
      expect(CountryStateSelect.countries_except([])).to include(sm)
    end

    it 'does not include the United States or Saint Martin if we exclude them explicitly' do
      expect(CountryStateSelect.countries_except(exceptions)).not_to include(exceptions)
    end

    it 'returns the same result as #countries_collection if no exceptions are passed' do
      expect(CountryStateSelect.countries_except).to eq(CountryStateSelect.countries_collection)
    end
  end

  describe '#states_collection' do
    let(:f) { double(object: {}) }
    let(:options) { { country: 'country_field_name', state: 'state_field_name' } }

    it 'should return 51 elements when we query for the United States' do
      expect(f.object).to receive(:country_field_name).and_return('US') # Set the form Country Field to US

      method_call = CountryStateSelect.states_collection(f, options)

      expect(method_call.class).to eq(Array)
      expect(method_call.size).to eq(51)
    end

    it 'should return a String when we query for Saint Martin' do
      expect(f.object).to receive(:country_field_name).and_return('MF') # Set the form Country Field to MF for Saint Martin
      expect(f.object).to receive(:state_field_name).and_return('')

      method_call = CountryStateSelect.states_collection(f, options)

      expect(method_call.class).to eq(String)
      expect(method_call.size).to eq(0)
    end

    it "should return the 'State from Form' if the Country requested returns no States" do
      expect(f.object).to receive(:country_field_name).and_return('MF') # Set the form Country Field to MF for Saint Martin
      expect(f.object).to receive(:state_field_name).and_return('State from Form')

      method_call = CountryStateSelect.states_collection(f, options)

      expect(method_call).to eq('State from Form')
    end
  end

  describe '#states_options' do
    let(:f) { double(object: {}) }
    let(:options) do
      { form: f, label: 'State / Province', field_names: { country: :country_field_name, state: :state_field_name } }
    end

    it 'should return a Hash' do
      expect(f.object).to receive(:country_field_name).and_return('US')

      method_call = CountryStateSelect.state_options(options)
      expect(method_call.class).to eq(Hash)
    end

    it 'should contain a key-value pair of as: => :string if no states are returned for the country' do
      expect(f.object).to receive(:country_field_name).and_return('MF')
      expect(f.object).to receive(:state_field_name).and_return('')

      method_call = CountryStateSelect.state_options(options)
      expect(method_call).to have_key(:as)
      expect(method_call[:as]).to eq(:string)
    end

    it "should not return a key called 'as' if we want a dropdown" do
      expect(f.object).to receive(:country_field_name).and_return('US')

      method_call = CountryStateSelect.state_options(options)
      expect(method_call).not_to have_key(:as)
    end

    it 'should have a label if one has been set' do
      expect(f.object).to receive(:country_field_name).and_return('US')

      method_call = CountryStateSelect.state_options(options)
      expect(method_call).to have_key(:label)
      expect(method_call[:label]).to eq(options[:label])
    end

    it 'should contain a collection of type Array if a country has states' do
      expect(f.object).to receive(:country_field_name).and_return('US')

      method_call = CountryStateSelect.state_options(options)
      expect(method_call).to have_key(:collection)
      expect(method_call[:collection].class).to eq(Array)
    end

    it 'should contain a collection of type String if a country has no states' do
      expect(f.object).to receive(:country_field_name).and_return('MF')
      expect(f.object).to receive(:state_field_name).and_return('')

      method_call = CountryStateSelect.state_options(options)
      expect(method_call).to have_key(:collection)
      expect(method_call[:collection].class).to eq(String)
    end
  end

  describe '#collect_states' do
    it 'returns an array' do
      method_call = CountryStateSelect.collect_states('US')
      expect(method_call.class).to eq(Array)
    end

    it 'returns the diffrent value for the key and value' do
      method_call = CountryStateSelect.collect_states('US')
      expect(method_call[0][0]).not_to eq(method_call[0][1])
    end

    it 'returns the value part of the key-value pair' do
      method_call = CountryStateSelect.collect_states('US')
      expect(method_call.first.first).to eq('Alaska')
    end

    it 'returns an empty array if there are no states in that Country' do
      method_call = CountryStateSelect.collect_states('MF')
      expect(method_call).to eq([])
    end
  end

  describe '#collect_cities' do
    it 'returns an array' do
      method_call = CountryStateSelect.collect_cities(:mp, :in)
      expect(method_call.class).to eq(Array)
    end

    it 'it should return same value if city is not duplicate with state with out sending country' do
      city_without_country = CountryStateSelect.collect_cities(:mp, '')
      city_with_country = CountryStateSelect.collect_cities(:mp, :in)
      expect(city_without_country).to eq(city_with_country)
    end

    it 'returns an empty array if there are no states in that Country' do
      method_call = CountryStateSelect.collect_cities('', '')
      expect(method_call).to eq(nil)
    end
  end
end
