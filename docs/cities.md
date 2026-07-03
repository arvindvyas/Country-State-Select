# City support

City data comes from the same [city-state](https://github.com/loureirorg/city-state) gem as countries and states. Coverage varies a lot by country — it's strong for the US and reasonably populated for many others, but it is not exhaustive. If a state has no city data, the field falls back to a plain text input, the same way a country with no states falls back for the state field.

Coverage gaps are a known limitation of the underlying data, not something this gem can fix directly — but you're not stuck with it: see [Custom data sources](../README.md#custom-data-sources) in the README to swap in your own city data (a database table, a paid geodata API, etc.) without changing any of your views or JavaScript.

## form_with

```erb
<div data-controller="country-state-select">
  <%= f.country_select :country %>
  <%= f.state_select :state, :country %>
  <%= f.city_select :city, :state, :country %>
</div>
```

`city_select` takes `(method, state_method, country_method, options = {}, html_options = {})` — it reads the model's current state and country to decide whether to render a `<select>` (data available) or a text `<input>` (no data for that state/country pair).

## simple_form

```erb
<% options = { form: f, field_names: { state: :state_field, country: :country_field } } %>
<%= f.input :city_field, CountryStateSelect.city_options(options) %>
```

## Direct API

```ruby
CountryStateSelect.collect_cities('CA', 'US')
# => ["Los Angeles", "San Francisco", ...]
```

## JavaScript

Any of the JS integrations (Stimulus, vanilla/Sprockets, or the legacy jQuery build) pick up a city field automatically when you pass `city_id` (or, for the Stimulus controller, add a `city` target) alongside `country_id`/`state_id`. See the README's [JavaScript setup](../README.md#javascript-setup) section.
