class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :age, :avatar

  include Rails.application.routes.url_helpers

  def avatar
    "#{Rails.application.default_url_options[:host]}#{rails_blob_path(object.avatar)}"
  end
end
