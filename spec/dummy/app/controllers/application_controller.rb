class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
