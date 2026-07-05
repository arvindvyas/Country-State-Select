# frozen_string_literal: true

# @author Sachin Singh

module CountryStateSelect
  module Rails
    class Engine < ::Rails::Engine
      initializer 'country_state_select.form_builder' do
        ActiveSupport.on_load(:action_view) do
          ActionView::Helpers::FormBuilder.include CountryStateSelect::FormBuilder
        end
      end

      # Sprockets/Propshaft: makes both the new dependency-free build
      # (vendor/assets/javascript/country_state_select_vanilla.js) and the
      # deprecated jQuery build resolvable via `//= require` or
      # `stylesheet_link_tag`, and makes app/javascript resolvable as an
      # asset path for importmap-rails pins (see config/importmap.rb).
      initializer 'country_state_select.assets' do |app|
        if app.config.respond_to?(:assets)
          app.config.assets.paths << root.join('app/javascript').to_s
          app.config.assets.paths << root.join('vendor/assets/javascript').to_s
        end
      end

      # Registers this engine's pins (country_state_select,
      # country_state_select/controller) with importmap-rails, if the host
      # app has it installed, so apps get them for free instead of having
      # to hand-write `pin "country_state_select", to: ...` themselves.
      # Safe to define even when importmap-rails isn't present — Rails
      # initializer ordering just no-ops a `before:` reference to a name
      # that doesn't exist.
      initializer 'country_state_select.importmap', before: 'importmap' do |app|
        next unless app.config.respond_to?(:importmap)

        app.config.importmap.paths << root.join('config/importmap.rb')
        app.config.importmap.cache_sweepers << root.join('app/javascript')
      end
    end
  end
end
