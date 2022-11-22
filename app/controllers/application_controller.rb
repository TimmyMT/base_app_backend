class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  private

  def render_forbidden
    render json: { message: 'Access denied' }, status: :forbidden
  end

  def render_unauthorized
    render json: { message: "Unauthorized" }, status: 401
  end
end
