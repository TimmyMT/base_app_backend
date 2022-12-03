module AccessHandler
  extend ActiveSupport::Concern

  def authenticate!
    check_bearer
  end

  private

  def check_bearer
    return render_unauthorized if request.env["HTTP_AUTHORIZATION"].nil?
    return render_unauthorized if request.env["HTTP_AUTHORIZATION"].include?("Bearer undefined")

    unpack_token
  end

  def unpack_token
    token = request.env["HTTP_AUTHORIZATION"].split(' ').last
    return render_unauthorized unless token_valid?(token)

    decoded_token = decode(token)

    verify_information(decoded_token.first)
  end

  def verify_information(user_info)
    user = User.find(user_info['id'])

    if user_info['email'] == user.email
      @current_user = user
    else
      render_unauthorized
    end
  end

  def decode(token)
    JWT.decode token, nil, false
  end

  def token_valid?(token)
    token = AccessToken.find_by(token: token)
    return false unless token
    return true if DateTime.now < token.expires_in

    false
  end
end