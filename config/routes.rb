Swprototype::Application.routes.draw do

  #  resource :bar_det

  get "bar_swigs/index"
  get "/:id" => "bar_detail#show", as: :bar_profile
  get "b/:b_id/:s_id" => "bar_detail#bar_swig", as: :bar_swig

  #  match "bars/show"

  root to:  "home#index"


  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", confirmations: "users/confirmations",passwords: "users/passwords", omniauth_callbacks: "users/omniauth_callbacks"}

  resource :users do
    collection do
      get "bar/:bar_id" => "users/bars#show", as: "bar_profile"
    end
  end
  devise_for :bars, controllers: {registrations: "bars/registrations", sessions: "bars/sessions", confirmations: "bars/confirmations", passwords: "bars/passwords"}

  devise_for :members, controllers: {registrations: "members/registrations"}



  namespace :bars do
    match  "dashboard" => "dashboard#index", as: "dashboard"
    match  "product" => "products#index", as: "product"
    post  "create_swig" => "dashboard#create_swig", as: "create_swig"
    post  "update_swig/:id" => "dashboard#update_swig", as: "update_swig"
    delete  "delete_swig/:id" => "dashboard#delete_swig", as: "delete_swig"
    post  "active_swig/:id" => "dashboard#active_swig", as: "active_swig"
    post  "deactive_swig/:id" => "dashboard#deactive_swig", as: "deactive_swig"
    post  "create_reward" => "dashboard#create_reward", as: "create_reward"
    post  "update_reward/:id" => "dashboard#update_reward", as: "update_reward"
    delete  "delete_reward" => "dashboard#delete_reward", as: "delete_reward"
    get "rewards/index"
    match "rewards" => "rewards#index", as: "rewards"
  end

  namespace :users do
    match  "user_dashboard" => "dashboard#index", as: "dashboard"
    #    get "bar_swigs/show"
    get  "show_swig/:bar_id/:swig_id" => "bar_swigs#show_swig", as: "show_swig"
    get  "enter_bar/:bar_id" => "bar_swigs#enter_bar", as: "enter_bar"
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
