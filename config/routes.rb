Rails.application.routes.draw do
  root to: 'questions#index'
  
  devise_for :users
  
  resources :questions do
    resources :answers do
      post 'set_as_best', on: :member, as: 'best'
    end
  end
end
