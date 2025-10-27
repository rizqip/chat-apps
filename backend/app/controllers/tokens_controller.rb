class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def index
    render json: { csrf_token: form_authenticity_token }
  rescue => e
    Rails.logger.error "Error in TokensController: #{e.message}"
    render json: { error: "Internal server error" }, status: :internal_server_error
  end
end