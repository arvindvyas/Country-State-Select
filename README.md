# Country State Select

[![Gem Version](https://img.shields.io/gem/v/country_state_select)](https://rubygems.org/gems/country_state_select)
[![CI](https://github.com/arvindvyas/Country-State-Select/actions/workflows/ci.yml/badge.svg)](https://github.com/arvindvyas/Country-State-Select/actions/workflows/ci.yml)
[![Downloads](https://img.shields.io/gem/dt/country_state_select)](https://rubygems.org/gems/country_state_select)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE.txt)

Country State Select gives you cascading Country → State/Province → City dropdowns for Rails forms: pick a country, the state field repopulates; pick a state, the city field repopulates.

![Cascading country, state, and city selects](docs/images/cascading-select-demo.png)

Country, state and city data comes from the [city-state](https://github.com/loureirorg/city-state) gem (pluggable — see [Custom data sources](#custom-data-sources)).

**v4.0 is a modernization release.** Highlights:

- Dependency-free JavaScript (no jQuery) with a bundled [Stimulus](https://stimulus.hotwired.dev/) controller
- Works with importmap-rails, Sprockets, Propshaft, or npm/esbuild/webpack
- Native `form_with`/`form_for` support (`f.country_select`, `f.state_select`, `f.city_select`) — simple_form is no longer required
- `priority_countries`, `only`/`except` filtering, flags, dial codes, I18n-localized names
- A pluggable data source adapter
- HTTP-cached JSON lookup endpoints
- An install generator (`rails g country_state_select:install`)

See the [CHANGELOG](CHANGELOG.md) for what changed in each release. Upgrading from 3.x? See [docs/migration-v4.md](docs/migration-v4.md) — the legacy jQuery/Chosen JavaScript still works, but Rails < 7.0 is no longer supported (stay on the 3.x gem for older Rails).

## Table of contents

- [Installation](#installation)
- [Supported versions](#supported-versions)
- [JavaScript setup](#javascript-setup)
- [JavaScript API](#javascript-api)
- [Using it in a form](#using-it-in-a-form)
- [Configuration](#configuration)
- [JSON API](#json-api)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

```ruby
gem 'country_state_select'
```

```
bundle install
rails g country_state_select:install   # optional: initializer + setup instructions
```

## Supported versions

| Gem version | Ruby | Rails |
|---|---|---|
| 4.x | 3.1 – 4.0 | 7.0 – 8.1 |
| 3.x | no minimum declared | 3.0 – 7.x (use 3.x for Rails < 7.0) |

CI tests every Ruby and Rails version listed for 4.x. Rails 7.0 and 7.1 and Ruby 3.1 and 3.2 are past end of life upstream; they still pass CI but may be dropped in a future major version.

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
  CountryStateSelect({
    country_id: "country_field_id",
    state_id: "state_field_id",
    city_id: "city_field_id" // optional
  })
})
```

All options are listed in [JavaScript API](#javascript-api). If you use Turbo without Stimulus, see [Turbo without Stimulus](#turbo-without-stimulus).

### npm / esbuild / webpack

The package is not on the npm registry yet. Install it from GitHub:

```
npm install github:arvindvyas/Country-State-Select @hotwired/stimulus
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

## JavaScript API

The Stimulus controller is a thin wrapper around one function. Call it directly when you aren't using Stimulus:

```js
const csc = CountryStateSelect({ country_id: "country", state_id: "state", city_id: "city" })
```

| Option | Default | Purpose |
|---|---|---|
| `country_id` | required | `id` of the country `<select>` |
| `state_id` | required | `id` of the state field |
| `city_id` | none | `id` of the city field; leave it out for a country → state form |
| `states_url` / `cities_url` | `/find_states` / `/find_cities` | Lookup endpoints, if you mounted them elsewhere |
| `state_placeholder` / `city_placeholder` | `""` | Text of the blank first option |
| `selected_state` / `selected_city` | none | Value to pre-select when the field is filled on page load. You can also set `data-selected-value` on the state field or `data-selected-city` on the state or city field |
| `announce` | `true` | Announce updates through an `aria-live` region |
| `enhance` | none | `function (selectEl, options)` called on every rebuilt `<select>`, e.g. to attach Tom Select. Return an object with `destroy()` so it can be torn down before the next rebuild |
| `enhance_options` | `{}` | Passed as the second argument to `enhance` |
| `offline_data` | none | Serve lookups from memory instead of the endpoints (see below) |

It returns `{ refresh, destroy }`:

- `refresh()` re-reads the fields and re-attaches listeners, e.g. after you replace the form's HTML. It can be called repeatedly; listeners are not duplicated.
- `destroy()` removes all listeners and tears down any `enhance` instances.

**How fields are updated.** When the country changes, the state field is rebuilt with the new options and the city field is cleared. If there is nothing to list, the field becomes a text input so the user can type a value. The rebuilt field keeps every attribute of the original (`id`, `name`, `class`, `required`, `aria-*`, `data-*`, and so on), so validation, accessibility labels and Stimulus targets survive. If the user changes the country or state again before a lookup returns, the older response is ignored.

**Tom Select without Stimulus:**

```js
CountryStateSelect({
  country_id: "country",
  state_id: "state",
  enhance: (el, opts) => new TomSelect(el, opts),
  enhance_options: { create: false }
})
```

**Offline data.** Skip the network by passing the lookup data up front. States are keyed by country code, cities by `"COUNTRY:STATE"`. A missing `cities` key falls back to the endpoint.

```js
CountryStateSelect({
  country_id: "country", state_id: "state", city_id: "city",
  offline_data: {
    states: { US: [["CA", "California"], ["NY", "New York"]] },
    cities: { "US:CA": ["Los Angeles", "San Francisco"] }
  }
})
```

### Turbo without Stimulus

The Stimulus controller cleans up after itself. With the plain function, destroy the instance before Turbo caches the page, or each visit leaves another listener on `document`:

```js
let csc
document.addEventListener("turbo:load", () => {
  csc = CountryStateSelect({ country_id: "country", state_id: "state", city_id: "city" })
})
document.addEventListener("turbo:before-cache", () => csc?.destroy())
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

The `priority_countries`, `only_countries` and `except_countries` settings shape the **country** list. They are not applied by the `/find_states` and `/find_cities` endpoints.

### Custom data sources

Swap out `city-state` (e.g. for a database table, or the `countries` gem) by implementing the adapter interface. The lookup endpoints, form helpers and `collect_*` methods all go through it, so no view or JavaScript changes are needed:

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

  # Optional: part of the lookup endpoints' ETag. Return something that
  # changes with your data so browsers don't keep serving a stale 304.
  def cache_key
    "my-data-#{Location.maximum(:updated_at).to_i}"
  end
end

CountryStateSelect.configure { |c| c.data_source = MyDataSource.new }
```

`cache_key` defaults to the class name. The lookup responses are HTTP-cached (1 day by default), and their `ETag` is built from the gem version, this key and the request params. If your data can change without a deploy, return a key that changes with it; otherwise browsers that already hold a response keep getting `304 Not Modified` until it expires.

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

Ruby specs:

```
bundle install
bundle exec rspec

# against a specific Rails version
BUNDLE_GEMFILE=gemfiles/rails_7.2.gemfile bundle install
BUNDLE_GEMFILE=gemfiles/rails_7.2.gemfile bundle exec rspec
```

JavaScript tests (Node's built-in test runner with jsdom, in `test/javascript/`):

```
npm ci
npm test
```

The JavaScript source of truth is `app/javascript/country_state_select/country_state_select.js`. After editing it, regenerate the Sprockets build and commit both files:

```
bundle exec rake js:build
```

The dummy Rails app used for the request specs lives in `spec/dummy` and doubles as a runnable demo:

```
cd spec/dummy
bin/rails server
```

CI runs the Ruby suite on Ruby 3.1–4.0 (latest Rails) and on Rails 7.0, 7.1, 7.2, 8.0 and 8.1 (see `gemfiles/`), plus the JavaScript tests.

## Contributing

1. Fork the repo and create a branch.
2. Make your change with a test: an RSpec example for Ruby, a `test/javascript/` test for the JS.
3. If you changed the JS source, run `bundle exec rake js:build`.
4. Run `bundle exec rspec` and `npm test`.
5. Add a line under the next version in `CHANGELOG.md`.
6. Open a pull request.

Bug reports and questions are welcome in [GitHub issues](https://github.com/arvindvyas/Country-State-Select/issues).

## License

Released under the [MIT License](LICENSE.txt).
