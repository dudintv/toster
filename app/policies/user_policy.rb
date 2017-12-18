class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    true
  end

  def edit?
    user.id == record.id
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def me?
    user
  end

  def others?
    user
  end
end
