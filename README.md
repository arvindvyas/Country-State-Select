##Country State Select [![Build Status](https://travis-ci.org/arvindvyas/Country-State-Select.svg?branch=master)](https://travis-ci.org/arvindvyas/Country-State-Select)  [![Code Climate](https://codeclimate.com/github/arvindvyas/Country-State-Select/badges/gpa.svg)](https://codeclimate.com/github/arvindvyas/Country-State-Select)

Country State Select is library which gives you all the country names and when you select any country then it also create the other select box with all the states name of that country

#Getting Started

Country State Select is released as a Ruby Gem. The gem is to be installed within a Ruby
or Rails application. To install, simply add the following to your Gemfile.

    gem 'country_state_select'
  
Run bundle install and don't forget to restart your server after you install a new gem.
  
##Usage

	It returns all the country name
  
 	CountryStateSelect::Constant::COUNTRIES
  
 	=> ["Afghanistan", "Aland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola",
                 "Anguilla", "Antarctica", "Antigua And Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria",
         ................................]        
  
 	It returns all the Indian states. 
    
 	CountryStateSelect::Constant::INDIAN_STATES

 	It return all the USA states.
 
 	CountryStateSelect::Constant::USA_STATES
       
 	It returns all the Canadian states.
   
 	CountryStateSelect::CANADIAN_STATES
    
 	It returns all the UK states.
  
 	CountryStateSelect::UK_STATES

##Version History

1.0.1

Added method 'countries_except' inside this can put all the countries which you do not want in to the country select option just you have to fetch countries by 
CountryStateSelect.countries_except('CountryName1','CountryName2'....)

1.0.0
  
It is the stable version which have all the feature
It also have support of chosen-rails

0.0.3 & 0.0.4 

In both the version state field will not update if you will select the country


##Very easy to create select box just follow below steps

	First put this to the application.js file to load the js file
	    
	    //= require country_state_select

	It will create for you a select option, just care about 'id' if you want to update your state field 

	    <%= f.select :country_name, CountryStateSelect::Constant::COUNTRIES, {}, id: 'country_id' %>

	Create your state like mention below, and take care about id of the select field if you will change this then it will now work as it should be 

	    <%= f.text_field :state_name ,:id=> 'state_name'%>

	If you want to store country id then use this select option it will store the country id inside the database if you want the state field update with this then you can put id field inside this also like we have mention in previous example  

	    <%= f.select(:country_id, options_for_select(Array[*CountryStateSelect::Constant::COUNTRIES.collect {|v,i| [v,
	    CountryStateSelect::Constant::COUNTRIES.index(v)] }], :selected => f.object)) %>

	If you want to fetch the country name By 'id' then you have to just write 

	    <%= CountryStateSelect::Constant::COUNTRIES['PASS THE COUNTRY ID WHICH YOU SAVE HERE'] %>


	NOTE :- It will update the state field when there will be India,United Kingdom,Canada and United States so except these country if you select other country then you have to manually enter the state name, we are working on this soon we will cover most of the country 
  
##Configure if want country_state_select with chosen_rails 

	Include both the gem in your Gemfile
	    gem 'chosen-rails'
	    gem 'country_state_select'
	  
	Include 'chosen-jquery' inside your application.js file
	    //= require chosen-jquery

	Include chosen inside stylesheet assets
	    *= require chosen

	Enable chosen javascript 

	Create one coffee-script file eg scaffold.js.coffee
		$(document).on 'ready page:load', ->
		  $('.chosen-select').change ->
		    if $('#state_name option').size() > 1
		      $("#state_name" ).chosen() //this will add the chosen-select in to the state select
		    $("#state_name_chosen").empty();
		      
		  $('.chosen-select').chosen
		    allow_single_deselect: true
		    no_results_text: 'No results matched'
		    width: '280px'

	And this file must be included in application.js
	    //= require chosen-jquery
	    //= require scaffold
	 above scaffold is required because we have put the js inside that if you put in other coffee file that that you have to include

	And the country select option will be 
	    <%= f.select :country_name, CountryStateSelect::Constant::COUNTRIES, {}, id: 'country_id', :class=>'chosen-select' %>
	And the state input box will be 
	    <%= f.text_field :state_name ,:id=>'state_name' %>

##Contributing to Country State Select

  Fork, fix, then send me a pull request.
  
##License

:include:license
