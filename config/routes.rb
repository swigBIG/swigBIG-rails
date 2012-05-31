Swprototype::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  constraints(Subdomain) do
    root to:  "bar_home#index"
    match "/" => "bar_home#index", as: "bar_home"
    devise_scope :bar do
      match "/sign_in" => "bars/sessions#new", :as => :sign_in_bars
      match "/sign_up" =>  "bars/registrations#new", :as => :sign_up_bars
    end
#    match  "/:id" => "bars/dashboard#index", as: "subdomain_bar_detail"
  end

  root to:  "home#main"
  
  get "bars/city/:id" =>  "home#city", as: "city"
  
  resource :home do
    collection do
      get "main" =>  "home#main", as: "main"
      get "find_by_radius" => "home#find_by_radius", as: "find_by_radius"
    end
  end

  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", confirmations: "users/confirmations",passwords: "users/passwords", omniauth_callbacks: "users/omniauth_callbacks"}

  get "bar/:bar_id" => "users/bars#show", as: "bar_profile"
  
  resource :users do
    collection do
    end
  end
  devise_for :bars, controllers: {registrations: "bars/registrations", sessions: "bars/sessions", confirmations: "bars/confirmations", passwords: "bars/passwords"}

  devise_for :members, controllers: {registrations: "members/registrations"}
  
  namespace :bars do
   
    match  "completion" => "dashboard#completion", as: "completion"
    get  "update_completion" => "dashboard#update_completion", as: "update_completion"
    match  "dashboard" => "dashboard#index", as: "dashboard"
    match  "product" => "products#index", as: "product"
    post  "create_reward_message/:user_id/:winner_id" => "dashboard#create_reward_message", as: "create_reward_message"
    post  "create_swig" => "dashboard#create_swig", as: "create_swig"
    post  "update_swig/:id" => "dashboard#update_swig", as: "update_swig"
    delete  "delete_swig/:id" => "dashboard#delete_swig", as: "delete_swig"
    post  "active_swig/:id" => "dashboard#active_swig", as: "active_swig"
    post  "deactive_swig/:id" => "dashboard#deactive_swig", as: "deactive_swig"
    #    post  "create_reward" => "dashboard#create_reward", as: "create_reward"
    post  "create_loyalty" => "dashboard#create_loyalty", as: "create_loyalty"
    post  "create_popularity" => "dashboard#create_popularity", as: "create_popularity"
    #    post  "update_reward/:id" => "dashboard#update_reward", as: "update_reward"
    post  "update_loyalty/:id" => "dashboard#update_loyalty", as: "update_loyalty"
    post  "update_popularity/:id" => "dashboard#update_popularity", as: "update_popularity"
    #    delete  "delete_reward/:id" => "dashboard#delete_reward", as: "delete_reward"
    delete  "delete_loyalty/:id" => "dashboard#delete_loyalty", as: "delete_loyalty"
    delete  "delete_popularity/:id" => "dashboard#delete_popularity", as: "delete_popularity"
    get "rewards/index"
    match "rewards" => "rewards#index", as: "rewards"
    post "create_bar_message" => "dashboard#create_bar_message", as: "create_bar_message"

    #    resources :messages do
    #      collection do
    #        get 'sent'
    #        post 'custom_action(/:form_type)' => "messages#custom_action", as: :custom_action
    #        get 'trash'
    #        get 'new(/:student_id(--:user_type))' => "messages#new", as: :new
    #      end
    #    end
  end
  resources :bars do

  end



  namespace :users do
    match  "notifications" => "notifications#index", as: "notifications"
    match  "user_dashboard" => "dashboard#index", as: "dashboard"
    match  "facebook_dashboard" => "dashboard#facebook_page", as: "facebook_page"
    match  "facebook_update_status" => "dashboard#facebook_update_status", as: "facebook_update_status"
    match  "invite_swigbig" => "dashboard#invite_swigbig", as: "invite_swigbig"
    post "invite_by_email" => "dashboard#invite_by_email", as: :invite_by_email
    match  "profile/:id" => "dashboard#show", as: "profile"
    match  "rewards" => "dashboard#rewards", as: "rewards"
    match  "update_account" => "dashboard#update_account", as: "update_account"
    match  "update_password" => "dashboard#update_password", as: "update_password"
    #    get "bar_swigs/show"
    get  "show_swig/:bar_id/:swig_id" => "bar_swigs#show_swig", as: "show_swig"
    get  "enter_bar/:bar_id" => "bar_swigs#enter_bar", as: "enter_bar"
    post "create_popularity/:bar_id" => "bars#create_popularity", as: "create_popularity"
    #--- friendship
    match "friendship" => "friends#index", as: "friend_index"
    post "friend_request/:id" => "friends#friend_request", as: "friend_request"
    post "remove_friend/:id" => "friends#remove_friend", as: :remove_friend
    post "approve_friend/:id" => "friends#approve_friend", as: :approve_friend

    #    resources :messages do
    #      collection do
    #        get 'sent'
    #        post 'custom_action(/:form_type)' => "messages#custom_action", as: :custom_action
    #        get 'trash'
    #        get 'new(/:student_id(--:user_type))' => "messages#new", as: :new
    #      end
    #    end
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
