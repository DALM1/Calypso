Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  resources :chat_rooms, except: :index do
    resources :messages, except: [:show, :edit, :update, :destroy] do
      resources :notifications, only: [:show, :index]
    end
  end
end
