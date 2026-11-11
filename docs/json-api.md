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

Resolves through the configured `data_source`, so a custom adapter is used here too. The country settings (`only_countries`, `except_countries`, `priority_countries`) are not applied: they shape the country list, and this endpoint returns the states of whatever country code it is given.

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

Both endpoints send `Cache-Control: public` and an `ETag` when `CountryStateSelect.configuration.cache_duration` is set (default: 1 day). Set `cache_duration = nil` to send neither.

The `ETag` is built from the gem version, the data source's `cache_key` and the request params. A conditional `GET` whose `If-None-Match` matches gets `304 Not Modified` with no body. Upgrading the gem (or the `city-state` gem, for the default data source) changes the `ETag`, so clients re-fetch. A custom data source whose data changes at runtime should return a changing `cache_key`; see [Custom data sources](../README.md#custom-data-sources).

## Routes

These are mounted at `/find_states` and `/find_cities` by default. See the README's [Custom route path](../README.md#custom-route-path) section to change that.
