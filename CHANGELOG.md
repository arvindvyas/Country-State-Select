# Changelog

## 4.0.0

Modernization release. See [docs/migration-v4.md](docs/migration-v4.md) for the full upgrade guide — existing 3.x code (Ruby API and the legacy jQuery JS) keeps working unchanged.

### Added
- Dependency-free JavaScript core (`app/javascript/country_state_select/country_state_select.js`), with builds for importmap-rails/npm (ESM) and Sprockets (`vendor/assets/javascript/country_state_select_vanilla.js`, compiled via `rake js:build`).
- A Stimulus controller (`country_state_select/controller`) with `states-url`/`cities-url`/`tom-select`/`announce`/`state-placeholder`/`city-placeholder` values.
- npm package (`package.json`) exposing the core and Stimulus controller as ES modules; `@hotwired/stimulus` is an optional peer dependency.
- Native `form_with`/`form_for` support: `f.country_select`, `f.state_select`, `f.city_select` — simple_form is no longer required. They render the model's current selection server-side (correct on edit forms without waiting on JS) and stamp Stimulus target data attributes automatically.
- `rails g country_state_select:install` generator (initializer + setup instructions).
- `CountryStateSelect.configure` with `priority_countries`, `only_countries`/`except_countries`, `flags`, `dial_codes`, `localize_names`, `cache_duration`, `draw_routes`, and a pluggable `data_source` (`CountryStateSelect::DataSources::Base`).
- `only:`/`except:`/`priority:` keyword options on `countries_collection`, `countries_except`, `collect_states`.
- Flag emoji and international dial code label decoration for countries.
- I18n-localized country names, with an optional soft integration with the `countries` gem.
- HTTP caching (`Cache-Control` + `ETag`, conditional `GET` → `304`) on the `/find_states`/`/find_cities` JSON endpoints; configurable via `cache_duration`.
- `config.draw_routes = false` + documented pattern for mounting the lookup routes at a custom path.
- An `aria-live` region announcing dropdown updates, and edit-form pre-population support in the new JS (skips a redundant AJAX round-trip when the server already rendered the correct selection; only fetches when a field is genuinely still a blank shell).
- `spec/dummy`: a runnable Rails 7/8 demo app (Propshaft + importmap + Stimulus) that doubles as the integration test target.
- CI matrix expanded to Rails 7.0/7.1/7.2/8.0 in addition to the Ruby version matrix (`gemfiles/`).
- `docs/json-api.md`, `docs/cities.md`, `docs/migration-v4.md`.

### Changed
- **Requires Rails >= 7.0 and Ruby >= 3.1.** Rails 3–6 support (`engine3.rb`, `railtie.rb`) removed — stay on `country_state_select` 3.x for older Rails.
- `cities_collection` (the simple_form helper) now actually passes the country through to the lookup, instead of silently ignoring it — see the migration guide if you relied on the old (incorrect) behavior.
- `/find_states` and `/find_cities` now resolve through the configured data source and `only`/`except`/`priority` filters rather than calling the underlying data gem directly.

### Deprecated
- The jQuery + Chosen JavaScript (`vendor/assets/javascript/country_state_select.js.erb`) is kept for backward compatibility but is deprecated in favor of the new dependency-free build.

## 3.3.1

### Fixed
- **CSRF / verb:** the `find_states` and `find_cities` lookup routes now accept
  `GET` (the correct verb for read-only data) in addition to `POST`, and the
  controller skips forgery protection. Previously the front-end's AJAX `POST`
  had no CSRF token and would raise `ActionController::InvalidAuthenticityToken`
  on a default Rails app. The bundled JavaScript now issues `GET` requests.
- **Data mutation:** `countries_collection` no longer calls `except!` (bang) on
  the hash that `city-state` memoizes, which permanently mutated the gem's
  shared country data for the process. It now uses a non-mutating `reject`.
- **Consistent return shape:** `collect_cities` now always returns an `Array`
  (empty when there is no data), matching `collect_states`, instead of `nil`.
- **Duplicate AJAX requests:** the state-change handler that triggers the city
  lookup is now bound once via event delegation instead of being re-bound on
  every country change (the old behaviour stacked listeners and fired multiple
  requests per change — the long-standing `[142] FIXME`).
- **JavaScript hardening:** option markup now quotes the `value` attribute and
  HTML-escapes labels; `html` and loop counters are properly scoped instead of
  leaking to the global object.

### Changed
- CI moved to GitHub Actions running the RSpec suite across Ruby 3.0–3.3. The
  unused Travis and CircleCI configs (the latter never ran the tests) were
  removed.
