## Country State Select
[![CI](https://github.com/arvindvyas/Country-State-Select/actions/workflows/ci.yml/badge.svg)](https://github.com/arvindvyas/Country-State-Select/actions/workflows/ci.yml)
[![Code Climate](https://codeclimate.com/github/arvindvyas/Country-State-Select/badges/gpa.svg)](https://codeclimate.com/github/arvindvyas/Country-State-Select)

Country State Select gives you cascading Country → State/Province → City dropdowns for Rails forms: pick a country, the state field repopulates; pick a state, the city field repopulates.

![Cascading country, state, and city selects](docs/images/cascading-select-demo.png)

Country/state/state data comes from the [city-state](https://github.com/loureirorg/city-state) gem (pluggable — see [Custom data sources](#custom-data-sources)).

**v4.0 is a modernization release.** Highlights:

- Dependency-free JavaScript (no jQuery) with a bundled [Stimulus](https://stimulus.hotwired.dev/) controller
- Works with importmap-rails, Sprockets, Propshaft, or npm/esbuild/webpack
- Native `form_with`/`form_for` support (`f.country_select`, `f.state_select`, `f.city_select`) — simple_form is no longer required
- `priority_countries`, `only`/`except` filtering, flags, dial codes, I18n-localized names
- A pluggable data source adapter
- HTTP-cached JSON lookup endpoints
- An install generator (`rails g country_state_select:install`)

Upgrading from 3.x? See [docs/migration-v4.md](docs/migration-v4.md) — the legacy jQuery/Chosen JavaScript still works, but Rails < 7.0 is no longer supported (stay on the 3.x gem for older Rails).

## Installation

```ruby
gem 'country_state_select'
```

```
bundle install
rails g country_state_select:install   # optional: initializer + setup instructions
```

Requires Rails >= 7.0 and Ruby >= 3.1.

## JavaScript setup

Pick the one that matches your app. All of them talk to the same `/find_states` and `/find_cities` JSON endpoints (see [docs/json-api.md](docs/json-api.md)).

### Importmap + Stimulus (Rails 7/8 default)

The engine registers its pins automatically — no `pin` lines to write yourself. In `app/javascript/application.js`:

```js
import "country_state_select"
import { Application } from "@hotwired/stimulus"
import CountryStateSelectController from "country_state_select/controller"

const application = Application.start()
application.register("country-state-select", CountryStateSelectController)
```

Or, with `stimulus-rails`' `app/javascript/controllers/index.js` auto-loading convention, just re-export it as its own controller file:

```js
// app/javascript/controllers/country_state_select_controller.js
export { default } from "country_state_select/controller"
```

Then in a view, wrap your fields in a controller container:

```erb
<div data-controller="country-state-select">
  <%= f.country_select :country %>
  <%= f.state_select :state, :country %>
  <%= f.city_select :city, :state, :country %>
</div>
```

Stimulus controller values (all optional, set as `data-country-state-select-<value>-value="..."`):

| Value | Default | Purpose |
|---|---|---|
| `states-url` | `/find_states` | Override if you disabled `draw_routes` and mounted the engine elsewhere |
| `cities-url` | `/find_cities` | Same, for cities |
| `tom-select` | `false` | Enhance the selects with [Tom Select](https://tom-select.js.org/) once populated (requires `TomSelect` to be loaded globally) |
| `announce` | `true` | Announce dropdown updates via an `aria-live` region |
| `state-placeholder` / `city-placeholder` | `""` | Blank option text shown before a real selection |

### Sprockets (no jQuery)

```js
//= require country_state_select_vanilla
```

```js
document.addEventListener('DOMContentLoaded', function () {
  CountryStateSelect({ country_id: "country_field_id", state_id: "state_field_id" })
})
```

### npm / esbuild / webpack

```
npm install country_state_select @hotwired/stimulus
```

```js
import CountryStateSelectController from "country_state_select/controller"
// or, for the framework-agnostic core directly:
import CountryStateSelect from "country_state_select"
```

`@hotwired/stimulus` is an optional peer dependency — only needed if you import the `/controller` entry point.

### Legacy jQuery + Chosen (deprecated)

Still bundled for apps upgrading from 3.x. New apps should use one of the options above.

```js
//= require country_state_select
//= require chosen-jquery   // optional, if you want the Chosen UI
```

```js
$(document).on('turbo:load', function () {
  CountryStateSelect({
    country_id: "country_field_id",
    state_id: "state_field_id",
    chosen_ui: true,
    chosen_options: { disable_search_threshold: 10 }
  })
})
```

## Using it in a form

### `form_with` (no simple_form required)

```erb
<%= form_with model: @business do |f| %>
  <div data-controller="country-state-select">
    <%= f.country_select :country, include_blank: true %>
    <%= f.state_select :state, :country %>
    <%= f.city_select :city, :state, :country %>
  </div>
<% end %>
```

- `state_select`/`city_select` read the model's *current* country/state to render the right options server-side — on an edit form, the saved state and city show up correctly without waiting on JavaScript.
- When the parent selection has no states/cities (e.g. a country with no states), the field renders as a plain text input, same as before.
- `only:`, `except:`, and `priority:` options work on all three: `f.country_select :country, priority: %w[US CA]`.

### simple_form (unchanged from 3.x)

```erb
<%= simple_form_for @form_object do |f| %>
  <%= f.input :country_field, collection: CountryStateSelect.countries_collection %>

  <% options = { form: f, field_names: { country: :country_field, state: :state_field } } %>
  <%= f.input :state_field, CountryStateSelect.state_options(options) %>
<% end %>
```

City support: see [docs/cities.md](docs/cities.md).

## Configuration

```ruby
# config/initializers/country_state_select.rb
CountryStateSelect.configure do |config|
  config.priority_countries = %w[US CA GB]   # shown first in the dropdown
  config.only_countries = %w[US CA GB IN]    # restrict the list
  config.except_countries = %w[KP]           # or exclude specific ones

  config.flags = true          # "🇮🇳 India"
  config.dial_codes = true     # "India (+91)"
  config.localize_names = true # translate names via I18n / the `countries` gem

  config.cache_duration = 1.day # HTTP cache on /find_states, /find_cities; nil disables it
  config.draw_routes = true     # set false to mount the engine at a custom path instead
end
```

Every option here can also be passed per-call: `CountryStateSelect.countries_collection(priority: %w[US])`, `f.country_select :country, only: %w[US CA]`.

### Custom data sources

Swap out `city-state` (e.g. for a database table, or the `countries` gem) by implementing the adapter interface:

```ruby
class MyDataSource < CountryStateSelect::DataSources::Base
  def countries
    { US: 'United States', IN: 'India' } # code => English name
  end

  def states(country_code)
    [[:CA, 'California'], [:NY, 'New York']] # [code, name] pairs
  end

  def cities(state_code, country_code)
    ['Los Angeles', 'San Francisco'] # plain names
  end
end

CountryStateSelect.configure { |c| c.data_source = MyDataSource.new }
```

### Custom route path

By default the engine draws `/find_states` and `/find_cities` at the top level. To mount it elsewhere:

```ruby
# config/initializers/country_state_select.rb
CountryStateSelect.configure { |c| c.draw_routes = false }
```

```ruby
# config/routes.rb
scope path: '/csc' do
  match 'find_states' => 'country_state_select/cscs#find_states', via: :get
  match 'find_cities' => 'country_state_select/cscs#find_cities', via: :get
end
```

Then pass the matching URLs to the JS: `states_url: '/csc/find_states'` (or the Stimulus `states-url-value`).

## JSON API

The lookup endpoints are documented in [docs/json-api.md](docs/json-api.md) — useful if you're driving the selects from a SPA or mobile client instead of the bundled JS.

## Development

```
bundle install
bundle exec rspec
```

The dummy Rails app used for integration tests lives in `spec/dummy` and doubles as a runnable demo:

```
cd spec/dummy
bin/rails server
```

CI runs the suite across Ruby 3.1–3.4 (latest Rails) and Rails 7.0/7.1/7.2/8.0 (see `gemfiles/`).

## Contributing

Fork, fix, then send a pull request.
