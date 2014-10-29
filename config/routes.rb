Rails.application.routes.draw do

  resources :firmen
  resources :stoffe
  resources :transportabschnitte
  resources :umschlaege
  
  resources :schiffe
  get 'read_schedules' => 'schiffe#read_schedules'
  get 'readMacs' => 'schiffe#readMacs', as: :read_macs
  
  resources :users
  get 'signup'  => 'users#new'
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get 'abfragen/index'

  post 'abfragen/show'

  get 'abfragen/calendar'

  get 'welcome/index'

  resources :transporte do 
    get 'union', on: :member
    #get 'edit_abschnitte', on: :member
    #post 'transporte/update_abschnitte', on: :member
  end

  resources :beobachtungen do
    get "abschnitt_zuordnen", on: :member
    get "load_foto", on: :member
    post "update_foto", on: :member
  end 
  get "beobachtungen/set_toleranz_tage/:id/:tage" => 'beobachtungen#set_toleranz_tage', as: :set_toleranz_tage_beobachtung

  resources :anlagen
  post "anlagen/add_synonym"
  post "anlagen/destroy_synonym"

  get "upload/index"
  post "upload/upload_file"
  post "upload/read_anlagen"
  get "upload/anlagen_zuordnung"
  post "upload/save_zuordnung"
  get "upload/stoffe_zuordnung"
  post "upload/save_stoffe_zuordnung"
  get "upload/anlagen_fertig_auswahl"
  get "upload/read_transporte"
  post "upload/save_transporte"
  get "upload/fertig"
  get "upload/join_transporte/:transporte_ids" => 'upload#join_transporte', as: :upload_join_transporte

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
