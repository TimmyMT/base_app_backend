class RefreshToken < ApplicationRecord
  belongs_to :user
  belongs_to :access_token
end
