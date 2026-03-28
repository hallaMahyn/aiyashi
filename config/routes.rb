Rails.application.routes.draw do
  # Public pages
  root "pages#home"
  get "/about",    to: "pages#about",    as: :about
  get "/services", to: "pages#services", as: :services_page
  get "/contacts", to: "pages#contacts", as: :contacts

  # Public inquiry form
  resources :inquiries, only: [:new, :create]

  # Devise for admin only — no public registration
  devise_for :admins, path: "admin/auth",
             controllers: { sessions: "admins/sessions" },
             skip: [:registrations, :passwords, :confirmations]

  # Admin namespace
  namespace :admin do
    root to: "inquiries#index"

    resources :inquiries, only: [:index, :show, :update, :destroy] do
      member { patch :update_status }
    end

    resources :services do
      member     { patch :toggle_active }
      collection { post :reorder }
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
