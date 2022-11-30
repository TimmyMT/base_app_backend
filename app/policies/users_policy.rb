class UsersPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def update?
    admin? || record == user
  end
end
