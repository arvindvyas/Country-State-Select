$(document).on 'ready page:load', ->
  CountryStateSelect({ chosen_ui: true, country_id: "location_test_country", state_id: "location_test_state", city_id: "location_test_city", city_place_holder: "Please select city", state_place_holder: 'Please select state' })
