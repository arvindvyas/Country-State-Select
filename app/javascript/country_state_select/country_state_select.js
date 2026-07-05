// Dependency-free core: no jQuery required. Works as an ES module (npm,
// importmap-rails, esbuild/webpack) and is also compiled by `rake js:build`
// into a plain-script build for Sprockets users — see
// vendor/assets/javascript/country_state_select_vanilla.js. Keep this file
// as the single source of truth; edit the compiled build only by re-running
// `rake js:build`.
//
// The legacy jQuery + Chosen implementation
// (vendor/assets/javascript/country_state_select.js.erb) is kept for
// backward compatibility but is deprecated — new apps should use this file,
// optionally through the bundled Stimulus controller (controller.js).

export default function CountryStateSelect(options) {
  var countryId = options.country_id;
  var stateId = options.state_id;
  var cityId = options.city_id;
  var hasCityField = !!cityId;
  var announce = options.announce !== false;
  var offlineData = options.offline_data || null;
  var statesUrl = options.states_url || '/find_states';
  var citiesUrl = options.cities_url || '/find_cities';
  var enhancer = options.enhance; // optional fn(selectEl, tomSelectOptions) e.g. Tom Select hookup
  var enhancerOptions = options.enhance_options || {};
  var liveRegion = announce ? ensureLiveRegion() : null;

  var enhancedInstances = {};

  init();

  return { refresh: init, destroy: destroy };

  // ====== ***** INITIALIZATION ***** ===================================== //

  function init() {
    enhance(countryId);

    var countryEl = document.getElementById(countryId);
    if (!countryEl) return;

    countryEl.addEventListener('change', function () {
      findStates(countryEl.value, { userInitiated: true });
    });

    if (hasCityField) {
      document.addEventListener('change', delegatedStateChange);
    }

    // Edit-form support: a server-rendered form (e.g. via the FormBuilder
    // helpers, which read the model's current country/state to pick the
    // right <select> options) already shows the correct state/city on
    // load — trust it and only enhance it, rather than discarding it for
    // a fresh, unselected fetch. Only fetch here for fields that truly
    // need it: a plain/manual integration where the target is still a
    // blank shell (a text input, or a <select> with no real options),
    // even though the country already has a value. Pre-selection for that
    // fetch comes from an explicit option or a `data-selected-value`/
    // `data-selected-city` attribute.
    var countryValue = countryEl.value;
    var stateEl = document.getElementById(stateId);
    var cityEl = hasCityField ? document.getElementById(cityId) : null;

    if (isPopulated(stateEl)) {
      enhance(stateId);
    } else if (countryValue) {
      var preselectedState = options.selected_state || (stateEl && stateEl.getAttribute('data-selected-value'));
      findStates(countryValue, { preselect: preselectedState, silent: true });
      return; // findStates cascades into the city fetch itself once it resolves
    }

    if (isPopulated(cityEl)) {
      enhance(cityId);
    } else if (hasCityField && stateEl && stateEl.value) {
      var preselectedCity = options.selected_city || (cityEl && cityEl.getAttribute('data-selected-city'));
      findCities(stateEl.value, countryValue, { preselect: preselectedCity, silent: true });
    }
  }

  function isPopulated(el) {
    return !!el && el.tagName === 'SELECT' && el.options.length > 1;
  }

  function destroy() {
    document.removeEventListener('change', delegatedStateChange);
  }

  function delegatedStateChange(event) {
    if (event.target && event.target.id === stateId) {
      findCities(event.target.value, document.getElementById(countryId).value, { userInitiated: true });
    }
  }

  // ====== ***** DATA LOOKUP ***** ========================================= //

  function findStates(countryCode, ctx) {
    ctx = ctx || {};
    if (ctx.userInitiated) findCities('', '', { silent: true });

    if (offlineData && offlineData.states) {
      buildStatesDropdown(offlineData.states[countryCode] || [], ctx);
      return;
    }

    fetchJson(statesUrl, { country_id: countryCode }).then(function (data) {
      buildStatesDropdown(data || [], ctx);
    });
  }

  function findCities(stateCode, countryCode, ctx) {
    ctx = ctx || {};
    if (!hasCityField) return;

    if (offlineData && offlineData.cities) {
      var key = countryCode + ':' + stateCode;
      buildCitiesDropdown(offlineData.cities[key] || [], ctx);
      return;
    }

    fetchJson(citiesUrl, { country_id: countryCode, state_id: stateCode }).then(function (data) {
      buildCitiesDropdown(data || [], ctx);
    });
  }

  function fetchJson(url, params) {
    var query = Object.keys(params)
      .map(function (k) { return encodeURIComponent(k) + '=' + encodeURIComponent(params[k] == null ? '' : params[k]); })
      .join('&');

    return fetch(url + '?' + query, {
      headers: { Accept: 'application/json' },
      credentials: 'same-origin'
    }).then(function (response) {
      if (!response.ok) return [];
      return response.json();
    }).catch(function () {
      return [];
    });
  }

  // ====== ***** DOM BUILDING ***** ======================================== //

  function buildStatesDropdown(data, ctx) {
    rebuildField(stateId, data, ctx.preselect, options.state_placeholder);
    if (!ctx.silent) announceUpdate('State options updated');

    var countryHasChanged = ctx.userInitiated;
    if (hasCityField) {
      if (countryHasChanged) {
        findCities('', '', { silent: true });
      } else if (ctx.preselect !== undefined) {
        var stateEl = document.getElementById(stateId);
        var preselectedCity = options.selected_city || (stateEl && stateEl.getAttribute('data-selected-city'));
        findCities(stateEl ? stateEl.value : '', countryId && document.getElementById(countryId).value, {
          preselect: preselectedCity,
          silent: true
        });
      }
    }
  }

  function buildCitiesDropdown(data, ctx) {
    rebuildField(cityId, data.map(function (name) { return [name, name]; }), ctx.preselect, options.city_placeholder);
    if (!ctx.silent) announceUpdate('City options updated');
  }

  // Rebuilds `fieldId` as a <select> (data present) or a plain text <input>
  // (no data for the parent selection) while preserving its id/name/class —
  // mutating the existing node in place rather than replaceWith() keeps
  // external references (Tom Select instances, other listeners) valid.
  function rebuildField(fieldId, pairs, preselectValue, placeholder) {
    var el = document.getElementById(fieldId);
    if (!el) return;

    destroyEnhancement(fieldId);

    if (!pairs || pairs.length === 0) {
      var input = document.createElement('input');
      input.type = 'text';
      input.id = fieldId;
      input.name = el.name;
      input.className = el.className;
      el.replaceWith(input);
      return;
    }

    var select = document.createElement('select');
    select.id = fieldId;
    select.name = el.name;
    select.className = el.className;

    var blank = document.createElement('option');
    blank.textContent = placeholder || '';
    blank.value = '';
    select.appendChild(blank);

    pairs.forEach(function (pair) {
      var opt = document.createElement('option');
      opt.value = pair[0];
      opt.textContent = pair[1];
      if (preselectValue != null && String(pair[0]) === String(preselectValue)) {
        opt.selected = true;
      }
      select.appendChild(opt);
    });

    el.replaceWith(select);
    enhance(fieldId);
  }

  function enhance(fieldId) {
    if (!fieldId || typeof enhancer !== 'function') return;
    var el = document.getElementById(fieldId);
    if (!el || el.tagName !== 'SELECT') return;

    enhancedInstances[fieldId] = enhancer(el, enhancerOptions);
  }

  function destroyEnhancement(fieldId) {
    var instance = enhancedInstances[fieldId];
    if (instance && typeof instance.destroy === 'function') instance.destroy();
    delete enhancedInstances[fieldId];
  }

  // ====== ***** ACCESSIBILITY ***** ======================================= //

  function ensureLiveRegion() {
    var existing = document.getElementById('country-state-select-live-region');
    if (existing) return existing;

    var region = document.createElement('div');
    region.id = 'country-state-select-live-region';
    region.setAttribute('aria-live', 'polite');
    region.setAttribute('role', 'status');
    region.style.position = 'absolute';
    region.style.width = '1px';
    region.style.height = '1px';
    region.style.overflow = 'hidden';
    region.style.clip = 'rect(0 0 0 0)';
    document.body.appendChild(region);
    return region;
  }

  function announceUpdate(message) {
    if (liveRegion) liveRegion.textContent = message;
  }
}
