class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: login_params[:email])

    if user&.valid_password?(login_params[:password])
      token = Tokens::Create.new(user).call

      render json: token, status: :created
    else
      render json: { error: 'Something went wrong. Please try again' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
