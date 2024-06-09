# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get '/posts', to: 'posts#index'
  get "up" => "rails/health#show", as: :rails_health_check
end
