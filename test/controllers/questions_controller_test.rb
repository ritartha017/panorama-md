require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    assert_difference('article.count') do
      post articles_url, params: { article: { body: @article.body, title: @article.title, views_count: @article.views_count } }
    end

    assert_redirected_to article_url(article.last)
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { body: @article.body, title: @article.title, views_count: @article.views_count } }
    assert_redirected_to article_url(@article)
  end

  test "should destroy article" do
    assert_difference('article.count', -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end
end
