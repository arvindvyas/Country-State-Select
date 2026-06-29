# Changelog

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
