class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :age, :avatar, :gender

  include Rails.application.routes.url_helpers

  def avatar
    return nil unless object.avatar.attached?

    "#{Rails.application.default_url_options[:host]}#{rails_blob_path(object.avatar)}"
  end
end
