AppengineRails3::Application.routes.draw do
  resources :comments, :only => [ :create ]
  
  root :to => 'homes#show'
end
