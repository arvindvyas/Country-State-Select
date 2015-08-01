#!/bin/env ruby
# encoding: utf-8

# @author Arvind Vyas

module CountryStateSelect
  require 'city-state'
  module CstData
    def self.countries
      CS.countries
    end

    def self.states(country)
      CS.states(country)
    end
  end
end