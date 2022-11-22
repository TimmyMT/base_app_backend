class UsersPolicy < ApplicationPolicy
  def index?
    admin?
  end
end
