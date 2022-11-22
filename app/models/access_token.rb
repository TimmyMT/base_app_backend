class AccessToken < ApplicationRecord
  belongs_to :user
  has_one :refresh_token, dependent: :destroy
end
