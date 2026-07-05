// Stimulus wrapper around country_state_select.js — the idiomatic way to
// wire this up on Rails 7/8 with Hotwire/Turbo and no manual JS per page.
//
//   <div data-controller="country-state-select"
//        data-country-state-select-tom-select-value="true">
//     <select data-country-state-select-target="country" ...>
//     <select data-country-state-select-target="state" ...>
//     <select data-country-state-select-target="city" ...>   (optional)
//   </div>
//
// Register it once in your controllers/index.js:
//
//   import { Application } from '@hotwired/stimulus'
//   import CountryStateSelectController from 'country_state_select/controller'
//   const application = Application.start()
//   application.register('country-state-select', CountryStateSelectController)
//
// Requires `@hotwired/stimulus` as a peer dependency in the host app —
// it is not bundled or re-exported by this package.
//
// Imports the bare specifier "country_state_select" (the importmap pin /
// npm package name) rather than a relative path — a relative import would
// resolve against this file's own fingerprinted asset URL under Sprockets/
// Propshaft (e.g. controller-a1b2c3.js), bypassing the import map entirely
// and 404ing, since browsers only consult import maps for bare specifiers.
import { Controller } from '@hotwired/stimulus';
import CountryStateSelect from 'country_state_select';

export default class CountryStateSelectController extends Controller {
  static targets = ['country', 'state', 'city'];
  static values = {
    statesUrl: { type: String, default: '/find_states' },
    citiesUrl: { type: String, default: '/find_cities' },
    tomSelect: { type: Boolean, default: false },
    announce: { type: Boolean, default: true },
    statePlaceholder: { type: String, default: '' },
    cityPlaceholder: { type: String, default: '' }
  };

  connect() {
    this.instance = CountryStateSelect({
      country_id: this.countryTarget.id,
      state_id: this.stateTarget.id,
      city_id: this.hasCityTarget ? this.cityTarget.id : undefined,
      states_url: this.statesUrlValue,
      cities_url: this.citiesUrlValue,
      state_placeholder: this.statePlaceholderValue,
      city_placeholder: this.cityPlaceholderValue,
      announce: this.announceValue,
      enhance: this.tomSelectValue ? this.tomSelectEnhancer.bind(this) : undefined
    });
  }

  disconnect() {
    if (this.instance) this.instance.destroy();
  }

  tomSelectEnhancer(selectEl, opts) {
    if (typeof TomSelect === 'undefined') {
      console.warn('country-state-select: tomSelectValue is true but TomSelect is not loaded'); // eslint-disable-line no-console
      return null;
    }

    return new TomSelect(selectEl, opts);
  }
}
