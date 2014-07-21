require "country_state_select/version"

require_file 'modules/constant'

module CountryStateSelect
 
  def self.countries
    COUNTRIES
  end

  def self.india
    INDIAN_STATES.concat(INDIAN_TERRIOTORY)
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
    INDIAN_STATES.concat(INDIAN_TERRIOTORY).concat(USA_STATE_LIST)concat(CANADIAN_STATES)concat(UK_STATES)
  end
end