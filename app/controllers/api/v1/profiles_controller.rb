class Api::V1::ProfilesController < ApplicationController
  skip_after_action :verify_authorized
  before_action :doorkeeper_authorize!

  def me
    head :ok
  end
end
