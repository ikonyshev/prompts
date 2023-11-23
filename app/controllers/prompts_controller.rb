class PromptsController < ApplicationController
  def index
    @count = Prompt.count
  end

  def search
    suggestions_query = params[:type] == 'vector' ?
          Prompt.search_vector(params[:query]) : Prompt.search(params[:query])

    @suggestions = suggestions_query.results

    # This is very dirty and better to use jbuilder, but I want quickly add scores to the response
    render json: @suggestions.map { |s| { score: s[:_score], text: s[:_source].text, id: s[:_source].id } }
  end
end
