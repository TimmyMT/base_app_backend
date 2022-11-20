class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.valid? && passwords_valid?
      user.save

      render json: { message: "You're registered successfully" }, status: 201
    else
      render json: { message: "Something went wrong, please try again" }, status: 400
    end
  end

  private

  def passwords_valid?
    return false if user_params[:password_confirmation].blank?
    return false if user_params[:password].blank?

    user_params[:password_confirmation] == user_params[:password]
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
