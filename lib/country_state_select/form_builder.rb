# frozen_string_literal: true

module CountryStateSelect
  # Native `form_with`/`form_for` support — `f.state_select` renders a plain
  # HTML <select> (or a text <input> when the current country has no states,
  # matching simple_form's `state_options` behavior) without requiring
  # simple_form. Both helpers stamp `data-controller`/`data-*-target`
  # attributes so the bundled Stimulus controller (app/javascript/
  # country_state_select/controller.js) wires up automatically — wrap the
  # fields in a `data-controller="country-state-select"` container and no
  # further JS is needed.
  module FormBuilder
    FILTER_KEYS = %i[only except priority].freeze

    def country_select(method, options = {}, html_options = {})
      collection = CountryStateSelect.countries_collection(options.slice(*FILTER_KEYS))
      merged_html = html_options.reverse_merge(data: { 'country-state-select-target': 'country' })

      select(method, collection, options.except(*FILTER_KEYS), merged_html)
    end

    def state_select(method, country_method, options = {}, html_options = {})
      country_value = object.public_send(country_method)
      states = CountryStateSelect.collect_states(country_value, **options.slice(*FILTER_KEYS))
      merged_html = html_options.reverse_merge(data: { 'country-state-select-target': 'state' })

      if states.empty?
        # FormBuilder#text_field (generated for the `field_helpers` list)
        # only takes (method, options) — html attributes and options share
        # one hash, unlike `select`'s separate options/html_options.
        text_field(method, options.except(*FILTER_KEYS).merge(merged_html))
      else
        select(method, states, options.except(*FILTER_KEYS), merged_html)
      end
    end

    def city_select(method, state_method, country_method, options = {}, html_options = {})
      cities = CountryStateSelect.collect_cities(object.public_send(state_method), object.public_send(country_method))
      merged_html = html_options.reverse_merge(data: { 'country-state-select-target': 'city' })

      if cities.empty?
        text_field(method, options.merge(merged_html))
      else
        select(method, cities.zip(cities), options, merged_html)
      end
    end
  end
end
