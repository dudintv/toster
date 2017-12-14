Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :authorizations, only: [:new, :create] do
    get 'confirm', on: :member
    post 'resend', on: :member
  end

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

  # API
  use_doorkeeper
  namespace :api do
    namespace :v1 do
      resources :profiles do
        collection do
          get :me
          get :others
        end
      end
      resources :questions do
        resources :answers
      end
    end
  end
end
