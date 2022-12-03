class Api::V1::UsersController < ApplicationController
  before_action :authenticate!, only: [:index, :update, :load_avatar]
  before_action :set_user, only: [:show, :update, :load_avatar]

  def index
    authorize(nil, policy_class: UsersPolicy)

    render json: User.all
  end

  def show
    render json: @user
  end

  def update
    authorize(@user, policy_class: UsersPolicy)
    
    if @user.update(profile_params)
      render json: @user
    else
      render_bad_request(@user.errors.messages)
    end
  end

  def load_avatar
    authorize(@user, policy_class: UsersPolicy)
    
    if @user.update(avatar: params[:avatar])
      render json: @user
    else
      render_bad_request(@user.errors.messages)
    end
  end

  def create
    user = User.new(user_params)
    return render_bad_request if !user.valid? && !passwords_valid?

    if user.valid?
      user.save
      UserMailer.send_confirm_mail(user).deliver
  
      render json: { message: "You're registered successfully" }, status: :created
    else
      render_bad_request(user.errors.messages)
    end
  end

  def confirm_account
    user = User.find_by_confirm_token(params[:id])
    return render_bad_request unless user

    user.email_activate

    render json: { message: 'Welcome to the Sample App! Your email has been confirmed' }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def passwords_valid?
    return false if user_params[:password_confirmation].blank?
    return false if user_params[:password].blank?

    user_params[:password_confirmation] == user_params[:password]
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :age, :gender)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
