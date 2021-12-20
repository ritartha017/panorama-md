require 'markovify'
require 'dataset_reader'

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

  # PUT /articles/1/upvote
  def upvote
    @article.increment! :positive_votes
    redirect_to article_path(@article), notice: "Article was upvoted."
  end

  # PUT /articles/1/downvote
  def downvote
    @article.increment! :negative_votes
    redirect_to article_path(@article), notice: "Article was downvoted."
  end

  # GET /articles
  def index
    @articles = Article.all
  end

  # GET /articles/1
  def show
    @article.increment! :views_count
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  def create
    random_data = Dataset.pick_random_article(Dataset.get_data_hash)
    text = random_data[0]
    source = random_data[1]
    @obj = Markovify.new(text: text, order: 2)
    ngrams_order, ngrams_size = (article_params.to_h.values).map(&:to_i)
    ngrams_order = 1 if ngrams_order.zero? == true
    ngrams_size = 30 if ngrams_size.zero? == true
    @article = Article.new(title: @obj.pp_markov_it(ngrams_order, true), body: @obj.pp_markov_it(ngrams_size), views_count: 1, source: source)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private
    def article_params
      params.require(:article).permit(:ngrams_order, :ngrams_size)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    def text
      "The unicorn is a legendary creature that has been described since antiquity as a beast with a single large, pointed, spiraling horn projecting from its forehead.
        In European literature and art, the unicorn has for the last thousand years or so been depicted as a white horse-like or goat-like animal with a long straight horn
        with spiralling grooves, cloven hooves, and sometimes a goat's beard. In the Middle Ages and Renaissance, it was commonly described as an extremely wild woodland creature,
        a symbol of purity and grace, which could be captured only by a virgin. In the encyclopedias, its horn was said to have the power to render poisoned water potable and to heal
        sickness. In medieval and Renaissance times, the tusk of the narwhal was sometimes sold as a unicorn horn."
    end
end
