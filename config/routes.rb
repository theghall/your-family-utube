Rails.application.routes.draw do

root 'static_pages#home'

get    '/help',      to: 'static_pages#help'
get    '/faq',       to: 'static_pages#faq'
get    '/parentfaq', to: 'static_pages#parentfaq'
get    '/about',     to: 'static_pages#about'
get    '/contact',   to: 'static_pages#contact'
get    '/privacy',   to: 'static_pages#privacy'

devise_for :users, :controllers => { registrations: 'registrations' }

resources :profiles, only: [:create]
resources :profiles_sessions, only: [:create]
resources :parentmode_sessions, only: [:new, :create, :destroy, :update]
resources :videos, only: [:show, :index, :create, :update, :destroy]
post     '/preload_video', to: 'videos#preload'
resources :tags, only: [:index]
resources :settings, only: [:index, :update]
end
