class ArticlesController < ApplicationController

  def index
    @generic_articles = Article.where(user_appliance_id: nil)
    @my_articles = Article.all.reject { |article| article.user_appliance_id == nil }
  end

  def show
    @article = Article.find(params[:id])
  end
end
