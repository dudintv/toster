module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_and_authorize_votable, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { id: @votable.id, value: @votable.sum_value, have_vote: true, positive_vote: true, type: model_klass.to_s }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: { id: @votable.id, value: @votable.sum_value, have_vote: true, positive_vote: false, type: model_klass.to_s }
  end

  def vote_cancel
    @votable.vote_cancel(current_user)
    render json: { id: @votable.id, value: @votable.sum_value, have_vote: false, type: model_klass.to_s }
  end

  private

  def load_and_authorize_votable
    @votable = model_klass.find(params[:id])
    authorize @votable
  end

  def model_klass
    controller_name.classify.constantize
  end
end
