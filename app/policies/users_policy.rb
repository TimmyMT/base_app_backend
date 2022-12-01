class UsersPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def update?
    admin_or_self?
  end

  def load_avatar?
    admin_or_self?
  end

  private

  def admin_or_self?
    admin? || record == user
  end
end
