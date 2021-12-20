Rails.application.routes.draw do
  resources :articles do
    put :upvote, :downvote, on: :member
  end
  root to: "home#index"
end
