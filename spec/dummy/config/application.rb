require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

# These ship as development_dependencies in the gem's own gemspec (they're
# only needed to boot this dummy test app), so they land in Bundler's
# :development group — outside `Rails.groups` in the test environment — and
# must be required explicitly rather than via `Bundler.require(*Rails.groups)`.
require "sqlite3"
require "propshaft"
require "importmap-rails"
require "stimulus-rails"

require "country_state_select"

module Dummy
  class Application < Rails::Application
    # The CI matrix runs this dummy app against Rails 7.0 through 8.x (see
    # gemfiles/), so the defaults version must track whichever Rails is
    # actually loaded rather than being pinned to one release.
    config.load_defaults "#{::Rails::VERSION::MAJOR}.#{::Rails::VERSION::MINOR}".to_f
    # autoload_lib was added in Rails 7.1; the CI matrix also runs 7.0.
    config.autoload_lib(ignore: %w[assets tasks]) if config.respond_to?(:autoload_lib)
    config.generators.system_tests = nil

    # No Rails credentials/master.key in this throwaway test app.
    config.secret_key_base = 'dummy-app-secret-key-base-for-tests-only'
  end
end
