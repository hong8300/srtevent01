Rails.application.routes.draw do
  get 'home/index'
  root to: 'home#index'

  ActiveAdmin.routes(self)

  # APIコントローラへのルーティング
  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :events, only: [:index, :show, :create, :update, :destroy]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
