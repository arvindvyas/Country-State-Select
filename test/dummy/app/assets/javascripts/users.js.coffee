$(document).on 'ready page:load', ->
  $('.chosen-select').change ->
    if $('#state_name option').size() > 1
      $("#state_name" ).chosen() //this will add the chosen-select in to the state select
    $("#state_name_chosen").empty();
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '280px'