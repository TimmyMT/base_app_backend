class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by!(email: login_params[:email])

    if user&.valid_password?(login_params[:password])
      token = Tokens::Create.new(user).call

      render json: token, status: :created
    else
      render json: { error: 'Something went wrong. Please try again' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: "User with email #{login_params[:email]} not found" }, status: :not_found
  end

  def refresh
    refresh_token = RefreshToken.find_by!(token: params[:token])
    token = Tokens::Create.new(refresh_token.user).call

    if token
      refresh_token.access_token.destroy

      render json: token, status: :created
    else
      render json: { error: 'Something went wrong. Please try again' }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Access denied" }, status: :unauthorized
  end

  def logout
    bearer = request.env["HTTP_AUTHORIZATION"]

    if bearer
      token = bearer.split(' ').last
      AccessToken.find_by!(token: token).destroy

      render json: {}, status: :no_content
    else
      render json: { error: "Bearer not included" }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Access denied" }, status: :unauthorized
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
