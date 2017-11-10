module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :vote_cancel]
    before_action :author_of?, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { id: @votable.id, score: @votable.sum_value, status: true, type: model_klass.to_s }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: { id: @votable.id, score: @votable.sum_value, status: true, type: model_klass.to_s }
  end

  def vote_cancel
    @votable.vote_cancel(current_user)
    render json: { id: @votable.id, score: @votable.sum_value, status: false, type: model_klass.to_s }
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def author_of?
    head :forbidden if current_user.author_of?(@votable)
  end

  def model_klass
    controller_name.classify.constantize
  end
end
