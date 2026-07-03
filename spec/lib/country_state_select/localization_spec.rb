# frozen_string_literal: true

require 'spec_helper'

describe CountryStateSelect::Localization do
  after do
    CountryStateSelect.reset_configuration!
    I18n.backend.reload!
  end

  describe '.country_name' do
    it 'returns the English name unchanged when localize_names is off' do
      expect(described_class.country_name(:FR, 'France')).to eq('France')
    end

    context 'when localize_names is on' do
      before { CountryStateSelect.configure { |c| c.localize_names = true } }

      it 'falls back to the English name when no translation is available' do
        expect(described_class.country_name(:FR, 'France')).to eq('France')
      end

      it 'uses a country_state_select.countries.<CODE> I18n key when present' do
        I18n.backend.store_translations(:en, country_state_select: { countries: { FR: 'La France' } })

        expect(described_class.country_name(:FR, 'France')).to eq('La France')
      end
    end
  end
end
