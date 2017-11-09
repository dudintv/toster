Rails.application.routes.draw do
  root to: 'questions#index'
  
  devise_for :users

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
      post 'vote_cancel'
    end
  end
  
  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable do
      post 'set_as_best', on: :member, as: 'best'
    end
  end

  resources :attachments, only: :destroy
end
