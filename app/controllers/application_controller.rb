class ApplicationController < ActionController::API
  include Pundit::Authorization
  include AccessHandler

  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  private

  def render_forbidden
    render json: { message: 'Access denied' }, status: :forbidden
  end

  def render_bad_request(error = 'Something went wrong. Please try again')
    render json: { error: error }, status: :bad_request
  end

  def render_unauthorized
    render json: { message: "Unauthorized" }, status: 401
  end
end
