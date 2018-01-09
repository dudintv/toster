class SearchController < ApplicationController
  respond_to :html

  def search
    authorize Search
    @results = Search.search(params[:search_string], params[:search_object].to_s)
    respond_with(@results)
  end
end
