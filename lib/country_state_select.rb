# frozen_string_literal: true

require 'yaml'
require 'country_state_select/version'
require 'country_state_select/configuration'
require 'country_state_select/data_sources/base'
require 'country_state_select/data_sources/city_state'
require 'country_state_select/localization'
require 'country_state_select/country_metadata'
require 'country_state_select/form_builder'
require 'rails'

module CountryStateSelect
  # Collect the Countries as [label, code] pairs, honoring configuration
  # (priority_countries, only/except, flags, dial_codes, localize_names)
  # and any per-call overrides passed in `options`.
  #
  #   CountryStateSelect.countries_collection
  #   CountryStateSelect.countries_collection(priority: %w[US IN], only: %w[US IN GB])
  def self.countries_collection(options = {})
    config = configuration
    raw = config.data_source_instance.countries

    only = options.fetch(:only, config.only_countries)
    except = options.fetch(:except, config.except_countries)
    priority = options.fetch(:priority, config.priority_countries)

    raw = raw.select { |code, _| only.map(&:to_s).include?(code.to_s) } if only
    raw = raw.reject { |code, _| except.map(&:to_s).include?(code.to_s) } if except

    labeled = raw.collect do |code, name|
      localized = Localization.country_name(code, name)
      [CountryMetadata.decorate(code, localized), code]
    end

    reorder_by_priority(labeled, priority)
  end

  # Pass array of unwanted countries to get back all except those in the array.
  # Kept for backward compatibility with 3.x; prefer `countries_collection(except: ...)`.
  def self.countries_except(*except)
    except = except.flatten.compact
    countries_collection(except: except.presence)
  end

  # Return either the State (String) or States (Array)
  def self.states_collection(f, options)
    states = collect_states(f.object.send(options[:country]), **filter_opts(options))
    return f.object.send(options[:state]) if states.empty?

    states
  end

  # Return either the City (String) or Cities (Array)
  def self.cities_collection(f, options)
    collect_cities(f.object.send(options[:state]), f.object.send(options[:country]))
  end

  # Return the raw [code, name] pairs for a given Country's states/provinces
  # — the shape the JSON lookup endpoint hands to the front-end (element 0
  # is the option value, element 1 is the label).
  def self.raw_states(country, only: nil, except: nil, priority: nil)
    return [] if country.nil? || country.to_s.empty?

    states = configuration.data_source_instance.states(country) # [[code, name], ...]
    states = states.select { |code, _| only.map(&:to_s).include?(code.to_s) } if only
    states = states.reject { |code, _| except.map(&:to_s).include?(code.to_s) } if except

    reorder_by_priority(states, priority, index: 0)
  end

  # Return the collected States for a given Country, as [name, code] pairs
  # — the shape simple_form/options_for_select expects (label, then value).
  def self.collect_states(country, only: nil, except: nil, priority: nil)
    raw_states(country, only: only, except: except, priority: priority).collect { |code, name| [name, code] }
  end

  # Return the cities of given state and country.
  def self.collect_cities(state_id = '', country_id = '')
    return [] if state_id.nil? || country_id.nil? || state_id.to_s.empty?

    configuration.data_source_instance.cities(state_id, country_id)
  end

  # Return a hash for use in the simple_form
  def self.state_options(options)
    states = states_collection(options[:form], options[:field_names])
    merge_hash(options, states)
  end

  # Return a hash for use in the simple_form
  def self.city_options(options)
    cities = cities_collection(options[:form], options[:field_names])
    merge_hash(options, cities)
  end

  # Create hash to use in the simple_form
  def self.merge_hash(options, collections)
    options = options.merge(collection: collections)
    options = options.merge(as: :string) if collections.instance_of?(String)
    options
  end

  # Moves entries whose code is in `priority` (in that order) to the front
  # of `collection`, followed by everything else in its original order.
  def self.reorder_by_priority(collection, priority, index: 1)
    return collection if priority.nil? || priority.empty?

    priority_codes = priority.map(&:to_s)
    by_code = collection.group_by { |entry| entry[index].to_s }

    head = priority_codes.filter_map { |code| by_code[code]&.first }
    tail = collection - head

    head + tail
  end
  private_class_method :reorder_by_priority

  def self.filter_opts(options)
    return {} unless options.is_a?(Hash)

    options.slice(:only, :except, :priority)
  end
  private_class_method :filter_opts
end

case ::Rails.version.to_s
when /^[7-9]\./, /^\d{2}\./
  require 'country_state_select/engine'
else
  raise 'Unsupported Rails version — CountryStateSelect 4.x requires Rails >= 7.0. Use CountryStateSelect 3.x for older Rails.'
end
