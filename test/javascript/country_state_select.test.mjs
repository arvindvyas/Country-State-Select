import { test, beforeEach, afterEach } from 'node:test';
import assert from 'node:assert/strict';
import { JSDOM } from 'jsdom';

const dom = new JSDOM('<!doctype html><html><body></body></html>');
globalThis.window = dom.window;
globalThis.document = dom.window.document;

const { default: CountryStateSelect } = await import('../../app/javascript/country_state_select/country_state_select.js');

let requests;
let instances = [];

function stubFetch() {
  requests = [];
  globalThis.fetch = (url) => new Promise((resolve) => {
    requests.push({
      url,
      respond: (data) => resolve({ ok: true, json: () => Promise.resolve(data) })
    });
  });
}

function requestFor(path, param) {
  const found = requests.find((r) => r.url.startsWith(`${path}?`) && r.url.includes(param));
  assert.ok(found, `expected a request to ${path} with ${param}`);
  return found;
}

function settle() {
  return new Promise((resolve) => setTimeout(resolve, 0));
}

function changeCountry(value) {
  const country = document.getElementById('country');
  country.value = value;
  country.dispatchEvent(new window.Event('change', { bubbles: true }));
}

function setup(options = {}) {
  const instance = CountryStateSelect({ country_id: 'country', state_id: 'state', city_id: 'city', announce: false, ...options });
  instances.push(instance);
  return instance;
}

beforeEach(() => {
  document.body.innerHTML = `
    <select id="country" name="address[country]">
      <option value=""></option><option value="US">United States</option><option value="IN">India</option>
    </select>
    <select id="state" name="address[state]" class="form-select" required aria-describedby="state-help"
            data-country-state-select-target="state"></select>
    <select id="city" name="address[city]" data-country-state-select-target="city"></select>`;
  stubFetch();
});

afterEach(() => {
  instances.forEach((instance) => instance.destroy());
  instances = [];
});

test('keeps the state field attributes when rebuilding it', async () => {
  setup();

  changeCountry('US');
  requestFor('/find_states', 'country_id=US').respond([['CA', 'California']]);
  await settle();

  const state = document.getElementById('state');
  assert.equal(state.tagName, 'SELECT');
  assert.equal(state.name, 'address[state]');
  assert.equal(state.className, 'form-select');
  assert.equal(state.required, true);
  assert.equal(state.getAttribute('aria-describedby'), 'state-help');
  assert.equal(state.getAttribute('data-country-state-select-target'), 'state');
});

test('keeps the attributes when a field becomes a text input', async () => {
  setup();

  changeCountry('US');
  requestFor('/find_states', 'country_id=US').respond([]);
  await settle();

  const state = document.getElementById('state');
  assert.equal(state.tagName, 'INPUT');
  assert.equal(state.type, 'text');
  assert.equal(state.required, true);
  assert.equal(state.getAttribute('data-country-state-select-target'), 'state');
});

test('ignores a states response that arrives after a newer country change', async () => {
  setup();

  changeCountry('US');
  changeCountry('IN');
  requestFor('/find_states', 'country_id=IN').respond([['MP', 'Madhya Pradesh']]);
  await settle();
  requestFor('/find_states', 'country_id=US').respond([['CA', 'California']]);
  await settle();

  const values = Array.from(document.getElementById('state').options).map((o) => o.value);
  assert.deepEqual(values, ['', 'MP']);
});

test('ignores a cities response for a state that is no longer selected', async () => {
  setup();
  changeCountry('US');
  requestFor('/find_states', 'country_id=US').respond([['CA', 'California'], ['NY', 'New York']]);
  await settle();

  const state = document.getElementById('state');
  state.value = 'CA';
  state.dispatchEvent(new window.Event('change', { bubbles: true }));
  state.value = 'NY';
  state.dispatchEvent(new window.Event('change', { bubbles: true }));
  requestFor('/find_cities', 'state_id=NY').respond(['New York City']);
  await settle();
  requestFor('/find_cities', 'state_id=CA').respond(['Los Angeles']);
  await settle();

  const cities = Array.from(document.getElementById('city').options).map((o) => o.value);
  assert.deepEqual(cities, ['', 'New York City']);
});

test('changing the country does not request cities', async () => {
  setup();

  changeCountry('US');
  requestFor('/find_states', 'country_id=US').respond([['CA', 'California']]);
  await settle();

  assert.deepEqual(requests.map((r) => r.url.split('?')[0]), ['/find_states']);
});

test('destroy removes the country listener', () => {
  setup().destroy();

  changeCountry('US');

  assert.equal(requests.length, 0);
});

test('refresh does not add a second country listener', () => {
  setup().refresh();

  changeCountry('US');

  assert.equal(requests.length, 1);
});
