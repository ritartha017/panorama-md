class HomeController < ApplicationController
  def index
    @articles_count = Article.count
    @popular_articles = Article.order(views_count: :desc).limit(5)
  end
end
