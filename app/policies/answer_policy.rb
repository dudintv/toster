class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.present?
  end

  def update?
    user&.author_of? record
  end

  def destroy?
    user&.author_of? record
  end

  def set_as_best?
    user&.author_of? record.question
  end
end
