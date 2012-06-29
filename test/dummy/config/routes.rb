Rails.application.routes.draw do

  resources :samples
  get "simulate/record"

  mount GraphMapperRails::Engine => "/graph_mapper_rails"
end
