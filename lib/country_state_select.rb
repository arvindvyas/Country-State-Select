# frozen_string_literal: true

require 'country_state_select/version'
require 'city-state'
require 'rails'

module CountryStateSelect
  # Collect the Countries
  def self.countries_collection
    CS.countries.except!(:COUNTRY_ISO_CODE).collect { |p| [p[1], p[0]] }.compact
  end

  # Pass array of unwanted countries to get back all except those in the array
  def self.countries_except(*except)
    countries_collection.collect { |c| c unless except.include?(c[1]) }.compact
  end

  # Return either the State (String) or States (Array)
  def self.states_collection(f, options)
    states = collect_states(f.object.send(options[:country]))
    return f.object.send(options[:state]) if states.empty?

    states
  end

  # Return either the City (String) or Cities (Array)
  def self.cities_collection(f, options)
    cities = collect_cities(f.object.send(options[:state]))
  end

  # Return the collected States for a given Country
  def self.collect_states(country)
    CS.states(country).collect { |p| [p[1], p[0]] }.compact
  end

  # Return the cities of given state and country
  def self.collect_cities(state_id = '', country_id = '')
    return [] if state_id.nil? || country_id.nil?

    CS.cities(state_id.to_sym, country_id.to_sym)
  end

  # Return a hash for use in the simple_form
  def self.state_options(options)
    states = states_collection(options[:form], options[:field_names])
    options = merge_hash(options, states)
  end

  # Return a hash for use in the simple_form
  def self.city_options(options)
    cities =  cities_collection(options[:form], options[:field_names])
    options = merge_hash(options, cities)
  end

  # Create hash to use in the simple_form
  def self.merge_hash(options, collections)
    options = options.merge(collection: collections)
    options = options.merge(as: :string) if collections.instance_of?(String)
    options
  end
end

case ::Rails.version.to_s
when /^[4-7]./
  require 'country_state_select/engine'
when /^3\.[12]/
  require 'country_state_select/engine3'
when /^3\.0/
  require 'country_state_select/railtie'
else
  raise 'Unsupported rails version'
end
