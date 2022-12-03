class User < ApplicationRecord
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_tokens, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy

  enumerize :gender, in: [:male, :female], predicates: true

  before_create :confirmation_token

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  private

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
