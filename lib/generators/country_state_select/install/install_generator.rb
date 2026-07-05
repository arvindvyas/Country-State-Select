# frozen_string_literal: true

require 'rails/generators/base'

module CountryStateSelect
  module Generators
    # rails g country_state_select:install
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Creates a CountryStateSelect initializer and prints JS setup instructions.'

      def copy_initializer
        template 'initializer.rb', 'config/initializers/country_state_select.rb'
      end

      def show_readme
        readme 'README' if behavior == :invoke
      end
    end
  end
end
