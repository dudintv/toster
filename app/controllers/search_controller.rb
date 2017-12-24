class SearchController < ApplicationController
  respond_to :html

  def search
    authorize Search
    @results = Search.search_result(params[:search_string], params[:search_object])
    respond_with(@results)
  end
end
