Rails.application.routes.draw do
  namespace :site do
    get 'welcome/index'
  end

  namespace :users_backoffice do
    get 'welcome/index'
  end

  namespace :admins_backoffice do
    get 'welcome/index'   # Dashboard
    resources :admins     # Admininistradores
    resources :subjects   # Assuntos/Areas
    resources :questions  # Perguntas
  end

  devise_for :admins
  devise_for :users
  root to: 'site/welcome#index'
end
