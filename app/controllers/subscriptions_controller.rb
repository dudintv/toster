class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  
  respond_to :js

  def create
    authorize Subscription
    @subscription = current_user.subscriptions.create(subscription_params)
    respond_with(@subscription, template: 'subscriptions/action')
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize @subscription
    respond_with(@subscription.destroy, template: 'subscriptions/action')
  end

  private

  def subscription_params
    params.require(:subscription).permit(:question_id)
  end
end
