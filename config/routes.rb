Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    root to: 'home#index'
    get 'users/delete_account', to: 'users/registrations#delete_account', as: 'delete_account'
    delete 'users/destroy_account', to: 'users/registrations#destroy_account', as: 'destroy_account'
    get 'goodbye', to: 'users/registrations#goodbye', as: 'goodbye'
  end

  resources :care_contents, only: [:new, :create, :edit, :update]
  resources :qr_codes, only: [:show, :index]

  get 'qr_codes/:id/scan', to: 'qr_codes#scan', as: 'scan_qr_code'
end
