class QuestionPolicy < ApplicationPolicy
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
    user.present?
  end

  def create?
    user.present?
  end

  def edit?
    user&.author_of? record
  end

  def update?
    user&.author_of? record
  end

  def destroy?
    user&.author_of? record
  end
end
