class RecommendationsController < ApplicationController
  def index
    @recommendations = Recommendation.all
  end
end
