AppengineRails3::Application.routes.draw do
  resources :comments, :only => [ :create, :destroy ]
  
  root :to => 'homes#show'
end
