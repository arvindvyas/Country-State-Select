# JSON lookup API

The engine exposes two read-only, cacheable JSON endpoints. They back the bundled JavaScript, but are documented here so a SPA, mobile app, or hand-rolled integration can call them directly.

## `GET /find_states`

**Params:** `country_id` — an ISO 3166-1 alpha-2 country code (e.g. `US`).

**Response:** an array of `[code, name]` pairs, or `[]` if the country has no states.

```
GET /find_states?country_id=US
```

```json
[["AK", "Alaska"], ["AL", "Alabama"], ["AR", "Arkansas"], ...]
```

Honors whatever `only_countries`/`except_countries`/`priority_countries` and custom `data_source` are configured — it does not bypass your configuration the way calling the underlying data gem directly would.

## `GET /find_cities`

**Params:** `state_id`, `country_id`.

**Response:** an array of plain city name strings, or `[]` if `state_id` is blank or the pair has no data.

```
GET /find_cities?state_id=CA&country_id=US
```

```json
["Los Angeles", "San Francisco", "San Diego", ...]
```

## Caching

Both endpoints send `Cache-Control` and `ETag` headers based on `CountryStateSelect.configuration.cache_duration` (default: 1 day). A conditional `GET` with a matching `If-None-Match` gets a `304 Not Modified` with no body. Set `cache_duration = nil` to disable both.

## Routes

These are mounted at `/find_states` and `/find_cities` by default. See the README's [Custom route path](../README.md#custom-route-path) section to change that.
