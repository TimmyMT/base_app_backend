class Api::V1::UsersController < ApplicationController
  before_action :authenticate!, only: [:index]

  def index
    authorize(nil, policy_class: UsersPolicy)

    render json: User.all
  end

  def show
    user = User.find(params[:id])

    render json: user
  end

  def create
    user = User.new(user_params)
    return render_bad_request if !user.valid? && !passwords_valid?

    user.save
    UserMailer.send_confirm_mail(user).deliver

    render json: { message: "You're registered successfully" }, status: 201
  end

  def confirm_account
    user = User.find_by_confirm_token(params[:id])
    return render_bad_request unless user

    user.email_activate

    render json: { message: 'Welcome to the Sample App! Your email has been confirmed' }
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
