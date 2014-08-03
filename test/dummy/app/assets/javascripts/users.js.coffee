$(document).on 'ready page:load', ->
  $('.chosen-select').change ->
    $("#state_name" ).chosen() //this will add the chosen-select in to the state select
  
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '280px'