# Migrating from 3.x to 4.0

## Requirements changed

- **Rails >= 7.0** is now required (Propshaft/importmap-rails, the default modern asset pipeline this release targets, itself requires Rails 7+). Rails 3–6 support (`engine3.rb`, `railtie.rb`) has been removed. If you're on an older Rails, stay on the `country_state_select` 3.x series.
- **Ruby >= 3.1** is now required.

## Nothing breaks if you do nothing

The Ruby API (`countries_collection`, `collect_states`, `state_options`, `city_options`, etc.) and the legacy jQuery/Chosen JavaScript (`vendor/assets/javascript/country_state_select.js.erb`) are unchanged and still work exactly as in 3.x, aside from the fixes below. You can upgrade the gem, bump your Rails version if needed, and keep everything else as-is.

## Behavior fixes worth knowing about

- **`cities_collection` (the simple_form helper) now actually filters by country.** In 3.x it silently ignored the `:country` key in `field_names` and only ever looked up cities by state, which meant it never respected the country half of a state/country pair. Duplicate state codes across countries would have picked up the wrong country's cities. If you were relying on that behavior, it's now consistent with `collect_cities(state, country)`, i.e. it needs `field_names` to include both `:state` and `:country`.
- **`/find_states` and `/find_cities` are HTTP-cached by default** (`Cache-Control` + `ETag`, 1 day). This is new — 3.x sent no caching headers at all. Set `CountryStateSelect.configure { |c| c.cache_duration = nil }` to opt out.
- **`/find_states` and `/find_cities` now go through your configured data source and `only`/`except`/`priority` filters**, not the `city-state` gem directly. This only changes behavior if you set those new options.

## New, opt-in features

Everything in the README's Configuration section — `priority_countries`, `only`/`except` filtering, `flags`, `dial_codes`, `localize_names`, a pluggable `data_source`, `draw_routes` — is new in 4.0 and defaults to off/unchanged, so adopting the gem doesn't require adopting any of it.

## If you want to modernize your JavaScript

You don't have to — the legacy jQuery/Chosen build keeps working — but if you want to drop the jQuery dependency:

1. Remove `//= require country_state_select` and `//= require chosen-jquery` (and the corresponding CSS `require`s) from your asset manifest.
2. Follow the README's [JavaScript setup](../README.md#javascript-setup) for whichever pipeline you use (importmap+Stimulus is the default for Rails 7/8 apps).
3. If you were using `chosen_ui: true`, the modern equivalent is [Tom Select](https://tom-select.js.org/) — Chosen is unmaintained. The Stimulus controller has a `tom-select` value for this; the vanilla/npm build takes an `enhance` callback for the same purpose.

## If you want to switch from simple_form to `form_with`

Also optional. `f.country_select`, `f.state_select`, `f.city_select` are new `form_with`/`form_for` builder methods that don't require simple_form — see the README's [Using it in a form](../README.md#using-it-in-a-form) section. Your existing simple_form-based views keep working unchanged.
