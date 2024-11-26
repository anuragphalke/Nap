require 'net/http'

class ProxyController < ApplicationController
  skip_before_action :authenticate_user!

  def proxy_request
    target_url = params[:url] # Pass the URL as a query parameter
    if target_url.present?
      uri = URI.parse(target_url)
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        render plain: response.body, status: :ok
      else
        render json: { error: "Failed to fetch the URL: #{response.message}" }, status: :bad_request
      end
    else
      render json: { error: "URL parameter is required" }, status: :bad_request
    end
  end
end


