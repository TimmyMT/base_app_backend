class Api::V1::SessionsController < ApplicationController
  before_action :authenticate!, only: :logout

  def create
    user = User.find_by(email: login_params[:email])
    return render_bad_request unless user&.valid_password?(login_params[:password])

    token = Tokens::Create.new(user).call

    render json: token, status: :created
  end

  def refresh
    refresh_token = RefreshToken.find_by(token: params[:token])
    return render_bad_request unless refresh_token

    token = Tokens::Create.new(refresh_token.user).call
    return render_bad_request unless token

    refresh_token.access_token.destroy

    render json: token, status: :created
  end

  def logout
    token = request.env['HTTP_AUTHORIZATION'].split(' ').last    
    AccessToken.find_by(token: token).destroy

    render json: {}, status: :no_content
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
