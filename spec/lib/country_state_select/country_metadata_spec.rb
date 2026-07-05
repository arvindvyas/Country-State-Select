# frozen_string_literal: true

require 'spec_helper'

describe CountryStateSelect::CountryMetadata do
  describe '.flag' do
    it 'converts a two-letter ISO code into its regional indicator flag emoji' do
      expect(described_class.flag(:US)).to eq("\u{1F1FA}\u{1F1F8}")
      expect(described_class.flag('IN')).to eq("\u{1F1EE}\u{1F1F3}")
    end

    it 'returns nil for a non two-letter code' do
      expect(described_class.flag('USA')).to be_nil
    end
  end

  describe '.decorate' do
    after { CountryStateSelect.reset_configuration! }

    it 'returns the plain name when flags and dial_codes are both off' do
      expect(described_class.decorate(:US, 'United States')).to eq('United States')
    end

    it 'prepends the flag when configured' do
      CountryStateSelect.configure { |c| c.flags = true }

      expect(described_class.decorate(:US, 'United States')).to start_with("\u{1F1FA}\u{1F1F8}")
    end

    it 'appends the dial code when configured' do
      CountryStateSelect.configure { |c| c.dial_codes = true }

      expect(described_class.decorate(:US, 'United States')).to eq('United States (+1)')
    end

    it 'combines flag and dial code when both are configured' do
      CountryStateSelect.configure { |c| c.flags = true; c.dial_codes = true }

      expect(described_class.decorate(:US, 'United States')).to eq("\u{1F1FA}\u{1F1F8} United States (+1)")
    end
  end
end
