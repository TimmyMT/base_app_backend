class ApplicationController < ActionController::API

  private

  def render_unauthorized
    render json: { message: "Unauthorized" }, status: 401
  end
end
