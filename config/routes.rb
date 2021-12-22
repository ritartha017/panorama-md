Rails.application.routes.draw do
  resources :articles do
    put :upvote, :downvote, on: :member
  end

  get 'about' => 'pages#about'
  root to: "home#index"
end
