class Tokens::Create
  attr_reader :user
  attr_accessor :payload

  def initialize(user)
    @user = user
    @payload = {}
    @expires_time = DateTime.now + 2.hour
    make_payload
  end

  def call
    user.transaction do
      if user.access_tokens.count > 2
        times_count = user.access_tokens.count - 2
        times_count.times { user.access_tokens.first.destroy }
      end
      refresh_salt = generate_verify_code
      access_token = user.access_tokens.create(
        user: user,
        token: encode(payload),
        expires_in: @expires_time,
        refresh: refresh_salt
      )
      RefreshToken.create!(
        access_token: access_token,
        user: access_token.user,
        token: refresh_salt
      )

      access_token
    end
  end

  private

  def encode(payload)
    JWT.encode payload, nil, 'HS256'
  end

  def make_payload
    payload[:id] = user.id
    payload[:email] = user.email
    payload[:admin] = user.admin
    payload[:salt] = generate_verify_code
    payload[:expires_in] = @expires_time
  end

  def generate_verify_code
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...64).map{ charset.to_a[rand(charset.size)] }.join
  end
end