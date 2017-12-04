Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  get 'authorizations/:id/confirm', to: 'authorizations#confirm', as: 'confirm_authorization'

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
      post 'vote_cancel'
    end
  end
  
  concern :commentable do
    resources :comments, only: [:create, :destroy]
  end
  
  resources :questions, shallow: true, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable] do
      post 'set_as_best', on: :member, as: 'best'
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
