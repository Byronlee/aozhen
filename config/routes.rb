Aozhen::Application.routes.draw do

  root :to => "home#index"
  resources :robots
  match 'command'     => 'robots#command'

end
