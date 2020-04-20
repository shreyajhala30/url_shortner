Rails.application.routes.draw do
  ## ROOT ##
  root to: 'url_data#new'

  ## URL ##
  resource :url_data, only: :create
  get '/:token', to: 'url_data#show'
end
