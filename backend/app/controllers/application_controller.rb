class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # CSRF protection
  protect_from_forgery with: :exception

  # Skip CSRF untuk API endpoints tertentu
  skip_before_action :verify_authenticity_token, if: :should_skip_csrf?
  
  before_action :debug_csrf

  private

  def debug_csrf
    if Rails.env.development?
      puts "=== CSRF DEBUG ==="
      puts "Request path: #{request.path}"
      puts "Request method: #{request.method}"
      puts "Content-Type: #{request.content_type}"
      puts "CSRF Token in header: #{request.headers['X-CSRF-Token']}"
      puts "Authenticity Token param: #{params[:authenticity_token]}"
      puts "Form Authenticity Token: #{form_authenticity_token}"
      puts "Verified?: #{verified_request?}"
      puts "=================="
    end
  end

  def should_skip_csrf?
    # Skip CSRF untuk:
    # - Request ke /api/nickname (POST)
    # - Request JSON/API lainnya
    api_request? || json_request?
  end

  def api_request?
    request.path == '/api/nickname' && request.post?
  end

  def json_request?
    request.content_type == 'application/json' || 
    request.format.json?
  end
end