Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/api' do
  	get '/pages/get', to: 'pages#get'
  	post '/pages/store', to: 'pages#store'
  end
end
