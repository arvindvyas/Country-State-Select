# frozen_string_literal: true

module CountryStateSelect
  # Optional label decoration: flag emoji and/or international dial code.
  # Both read from a small bundled table so the gem stays dependency-free;
  # a country missing from the table (rare, mostly disputed territories)
  # simply renders without the decoration instead of raising.
  module CountryMetadata
    DIAL_CODES = YAML.safe_load_file(
      File.expand_path('data/dial_codes.yml', __dir__)
    ).freeze

    def self.decorate(code, name)
      label = name
      label = "#{flag(code)} #{label}" if CountryStateSelect.configuration.flags && flag(code)
      label = "#{label} (+#{DIAL_CODES[code.to_s]})" if CountryStateSelect.configuration.dial_codes && DIAL_CODES[code.to_s]
      label
    end

    # Converts a two-letter ISO code to its flag emoji via the Unicode
    # "Regional Indicator Symbol" trick (each letter A-Z maps to U+1F1E6..).
    def self.flag(code)
      chars = code.to_s.upcase.chars
      return nil unless chars.length == 2 && chars.all? { |c| c.match?(/[A-Z]/) }

      chars.map { |c| [0x1F1E6 + (c.ord - 'A'.ord)].pack('U') }.join
    end
  end
end
