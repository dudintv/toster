class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.present?
  end

  def destroy?
    record.user_id == user.id
  end
end
