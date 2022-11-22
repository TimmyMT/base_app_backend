Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :users
      resources :sessions do
        collection do
          post :refresh
          delete :logout
        end
      end
    end
  end
end
