class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    user.id == record.id
  end

  def update?
    user.id == record.id
  end

  def destroy?
    user.id == record.id
  end

  def me?
    user.present?
  end

  def others?
    user.present?
  end
end
