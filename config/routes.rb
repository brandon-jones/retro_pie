RetroPie::Application.routes.draw do

  resources :faqs

  resources :payments

  resources :order_items

  resources :statuses
  
  resources :users do
    collection do
      post 'receipt'
    end
  end

  resources :items

  # post 'verify_order/:id', to: 'orders#submit_order'

  # delete '/order/:id', to: 'orders#destroy', as: :destory_order

  # get 'orders/stats', to: 'orders#stats'

  resources :orders do
    member do
      patch 'update'
      get 'verify'
      post 'verify'
    end
    collection do
      post 'update_status'
      post 'appreciation'
      get 'sorry'
      get 'status'
      get 'stats'
    end
  end

  resources :categories

  get 'manage', to: 'static_pages#manage'

  # get 'order_status', to: 'orders#status'

  # get 'verify_order/:id', to: 'orders#verify_order', as: :verify_order

  # get 'order/appreciation', to: 'orders#appreciation'


  # get 'faq', to: 'static_pages#faq'

  post 'scrape_data', to: 'items#scrape_data'

  get 'contact_me', to: 'static_pages#contact_me'
  post 'contact_me', to: 'static_pages#contact_me'

  root 'static_pages#index'

  # post 'orders/update', to: 'orders#update_orders'


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
