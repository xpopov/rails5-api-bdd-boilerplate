class ApplicationController < ActionController::API
    
  # URL parameter missing
  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # URL malformed
  rescue_from URI::InvalidURIError do |e|
    render json: { error: e.message }, status: :not_found
  end

  # URL not allowed
  rescue_from InvalidURLParameter do |e|
    render json: { error: e.message }, status: :not_found
  end

  # URL is not in DB
  rescue_from ActiveRecord::RecordNotFound do
    render body: nil, status: :not_found
  end

  # Cannot connect to website
  rescue_from SocketError do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

end
