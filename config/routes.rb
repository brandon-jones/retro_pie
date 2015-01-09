RetroPie::Application.routes.draw do
  resources :order_items

  resources :statuses

  resources :items

  delete '/order/:id', to: 'orders#destroy', as: :destory_order

  get 'orders/stats', to: 'orders#stats'

  resources :orders

  resources :categories

  get 'manage', to: 'static_pages#manage'

  get 'order_status', to: 'orders#status'

  get 'verify_order/:id', to: 'orders#verify', as: :verify_order

  post 'verify_order', to: 'orders#verify_order'

  get 'faq', to: 'static_pages#faq'

  post 'scrape_data', to: 'items#scrape_data'

  root 'static_pages#index'

  post 'orders/update', to: 'orders#update_orders'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
