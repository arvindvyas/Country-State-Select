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

  module Rails

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