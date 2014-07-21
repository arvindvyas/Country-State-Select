require "country_state_select/version"

require 'country_state_select/constant'

module CountryStateSelect
  include CountryStateSelect::Constant
 
  def self.countries
    COUNTRIES
  end

  def self.india
    INDIAN_STATES.merge(INDIAN_TERRIOTORY)
  end

  def self.us_states
    USA_STATE_LIST
  end
  
  def self.canadian_states
    CANADIAN_STATES
  end
  
  def self.uk_states 
    UK_STATES
  end

  def self.all_states
    INDIAN_STATES.merge(INDIAN_TERRIOTORY).merge(USA_STATE_LIST).merge(CANADIAN_STATES).merge(UK_STATES)
  end
end