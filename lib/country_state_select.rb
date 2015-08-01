require "country_state_select/version"
require 'country_state_select/cst_data'

module CountryStateSelect
  include CountryStateSelect::CstData
  
  def self.countries
    CountryStateSelect::CstData.countries
  end

  def self.india
    CountryStateSelect::CstData.states("IN")
  end

  def self.us_states
    CountryStateSelect::CstData.states("US")
  end
  
  def self.canadian_states
    CountryStateSelect::CstData.states("CA")
  end
  
  def self.uk_states 
    CountryStateSelect::CstData.states("GB")
  end

  #this method will provide the user to opetion to skip any countries in drop down list 
  def self.countries_except(*except)
    countries = []
    self.countries.each do |country|
      countries<< country unless  country.in?(except)
    end
    return countries
  end
end

case ::Rails.version.to_s
  when /^4/
    require 'country_state_select/engine'
  when /^3\.[12]/
    require 'country_state_select/engine3'
  when /^3\.[0]/
    require 'country_state_select/railtie'
  else
    raise 'Unsupported rails version'
end
