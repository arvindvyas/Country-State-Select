require "reform/form/validation/unique_validator.rb"

class LocationForm < Reform::Form

  include ModelReflections

  property :test_country
  property :test_state
  property :test_city

end