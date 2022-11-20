class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      token = Tokens::Create.new(user).call

      render json: token, status: :created
    else
      render json: { error: 'Something went wrong. Please try again' }, status: :unauthorized
    end
  end
end
