Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'games#index'

  resources :games do
    post 'throw', on: :member
  end
end
