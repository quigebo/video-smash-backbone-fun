VideoSmash::Application.routes.draw do
  resources :videos,   :only => :index
  resources :viewings, :only => [:index, :create]

  root :to => 'statics#home'
end
