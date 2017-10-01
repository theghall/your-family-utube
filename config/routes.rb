Rails.application.routes.draw do

  get 'tags/index'

root 'static_pages#home'

get    '/help',     to: 'static_pages#help'
get    '/about',    to: 'static_pages#about'
get    '/contact',  to: 'static_pages#contact'
get     '/parent',  to: 'static_pages#parent'

devise_for :users, :controllers => { registrations: 'registrations' }

resources :profiles, only: [:create]
resources :profiles_sessions, only: [:create]
resources :parentmode_sessions, only: [:new, :create, :destroy]
resources :videos, only: [:show, :index, :create, :update, :destroy]
post     '/preload_video', to: 'videos#preload'
resources :tags, only: [:index]
end
