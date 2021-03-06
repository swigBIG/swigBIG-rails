Swprototype::Application.routes.draw do
  get "home/index"

  mount Ckeditor::Engine => '/ckeditor'

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
  
  match "bars/city/:id" =>  "home#city", as: "city"
  get "live_swig_feed" =>  "request#live_swig_feed", as: "live_swig_feed"
  #  get "live_swig_feed" =>  "home#live_swig_feed", as: "live_swig_feed"
  #  post "set_time_zone" =>  "application#set_time_zone", as: "set_time_zone"
  get "set_time_zone" =>  "application#set_time_zone", as: "set_time_zone"


  resource :home do
    collection do
      get "main" =>  "home#main", as: "main"
      get "contact_us" =>  "home#contact_us", as: "contact_us"
      get "contact_us_for_homepage" =>  "home#contact_us_for_homepage", as: "contact_us_for_homepage"
      post "create_contact_us" =>  "home#create_contact_us", as: "create_contact_us"
      get "bars_list_to_swig" =>  "home#bars_list_to_swig", as: "bars_list_to_swig"
      get "mobile_dashboard" =>  "home#mobile_dashboard", as: "mobile_dashboard"
      match "sign_out_turning_point" =>  "home#sign_out_turning_point", as: "sign_out_turning_point"
      #      post "get_latitude_and_longitude_from_mobile/:data" =>  "home#get_latitude_and_longitude_from_mobile", as: "get_latitude_and_longitude_from_mobile"
    end
  end

  resource :request do 
    collection do
      match "invitations" =>  "request#invitations", as: "invitations"
      post "create_request" =>  "request#create_request", as: "create_request"
      match "welcome" =>  "request#welcome", as: "welcome"
      post "login_to_swigbig" =>  "request#login_to_swigbig", as: "login_to_swigbig"
      match "login" =>  "request#login", as: "login"
      match "select_type" =>  "request#select_type", as: "select_type"
    end
  end

  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", confirmations: "users/confirmations",passwords: "users/passwords", omniauth_callbacks: "users/omniauth_callbacks"}
  devise_scope :user do
    post "/update_picture_from_facebook" => "users/omniauth_callbacks#update_picture_from_facebook", :as => :update_picture_from_facebook
  end

  get "bar/:bar_id" => "users/bars#show", as: "bar_profile"
  
  resource :users do
    collection do
    end
  end
  
  devise_for :bars, controllers: {registrations: "bars/registrations", sessions: "bars/sessions", confirmations: "bars/confirmations", passwords: "bars/passwords"}

  devise_for :members, controllers: {registrations: "members/registrations"}
  
  namespace :bars do
    get "delete_swig/:id" => "dashboard#delete_swig", as: "delete_swig"
    match  "invite_friend" => "dashboard#after_join_invite_friends", as: "after_join_invite_friends"
    post  "invite_friend_by_email" => "dashboard#invite_friend_by_email", as: "invite_friend_by_email"
    match  "sport_lists" => "dashboard#sport_lists", as: "sport_lists"
    match  "users_lists" => "dashboard#users_lists", as: "users_lists"
    match  "completion" => "dashboard#completion", as: "completion"
    post  "update_completion" => "dashboard#update_completion", as: "update_completion"
    match  "second_completion" => "dashboard#second_completion", as: "second_completion"
    post  "update_second_completion" => "dashboard#update_second_completion", as: "update_second_completion"
    match  "dashboard" => "dashboard#index", as: "dashboard"
    match  "product" => "products#index", as: "product"
    post  "create_reward_message/:user_id/:winner_id" => "dashboard#create_reward_message", as: "create_reward_message"
    post  "create_swig" => "dashboard#create_swig", as: "create_swig"
    post  "create_big_swig" => "dashboard#create_big_swig", as: "create_big_swig"
    post  "update_big_swig" => "dashboard#update_big_swig", as: "update_big_swig"
    get  "delete_big_swig/:ids" => "dashboard#delete_big_swig", as: "delete_big_swig"
    post  "update_swig/:id" => "dashboard#update_swig", as: "update_swig"
    post  "create_loyalty" => "dashboard#create_loyalty", as: "create_loyalty"
    post  "create_popularity" => "dashboard#create_popularity", as: "create_popularity"
    #    post  "update_reward/:id" => "dashboard#update_reward", as: "update_reward"
    get "edit_loyalty/:id" => "dashboard#edit_loyalty", as: :edit_loyalty
    get "new_loyalty" => "dashboard#new_loyalty", as: :new_loyalty
    get "edit_popularity/:id" => "dashboard#edit_popularity", as: :edit_popularity
    get "new_popularity" => "dashboard#new_popularity", as: :new_popularity
    post  "update_loyalty/:id" => "dashboard#update_loyalty", as: "update_loyalty"
    post  "update_popularity/:id" => "dashboard#update_popularity", as: "update_popularity"
    #    delete  "delete_reward/:id" => "dashboard#delete_reward", as: "delete_reward"
    delete  "delete_loyalty/:id" => "dashboard#delete_loyalty", as: "delete_loyalty"
    delete  "delete_popularity/:id" => "dashboard#delete_popularity", as: "delete_popularity"
    get "rewards/index"
    match "rewards" => "rewards#index", as: "rewards"
    post "create_bar_message" => "dashboard#create_bar_message", as: "create_bar_message"
    post  "create_gift" => "dashboard#create_gift", as: "create_gift"
    post  "activate_loyalty/:loyalty_id" => "dashboard#activate_loyalty", as: "activate_loyalty"
    post  "deactivate_loyalty/:loyalty_id" => "dashboard#deactivate_loyalty", as: "deactivate_loyalty"
    post  "activate_popularity/:popularity_id" => "dashboard#activate_popularity", as: "activate_popularity"
    post  "deactivate_popularity/:popularity_id" => "dashboard#deactivate_popularity", as: "deactivate_popularity"
    post  "update_gift/:gift_id" => "dashboard#update_gift", as: "update_gift"
    get  "destroy_gift_in_list/:gift_id" => "dashboard#destroy_gift_in_list", as: "destroy_gift_in_list"
    post  "add_bigswig_list" => "dashboard#add_bigswig_list", as: "add_bigswig_list"
    post  "add_bigswig_list_on_update" => "dashboard#add_bigswig_list_on_update", as: "add_bigswig_list_on_update"
    post  "add_bar_hours" => "dashboard#add_bar_hours", as: "add_bar_hours"
    post  "add_bar_hours_on_edit" => "dashboard#add_bar_hours_on_edit", as: "add_bar_hours_on_edit"
    post  "add_reward_to_list" => "dashboard#add_reward_to_list", as: "add_reward_to_list"
    get  "destroy_bar_big_swig_list/:bigswiglist_id" => "dashboard#destroy_bar_big_swig_list", as: "destroy_bar_big_swig_list"
    post  "update_bar_big_swig_list/:bigswiglist_id" => "dashboard#update_bar_big_swig_list", as: "update_bar_big_swig_list"
    post  "search_redeem_code/:code" => "dashboard#search_redeem_code", as: "search_redeem_code"
    get  "swiger_list" => "dashboard#swiger_list", as: "swiger_list"
    post  "update_bar_hours" => "dashboard#update_bar_hours", as: "update_bar_hours"
    get  "swigger_total_count" => "dashboard#swigger_total_count", as: "swigger_total_count"
    get "reward_stats" => "dashboard#reward_stats", as: :reward_stats

    resources :messages do
      collection do
        get  "notify_mark_all_read" => "messages#notify_mark_all_read", as: "notify_mark_all_read"
        get  "messages_mark_all_read" => "messages#messages_mark_all_read", as: "messages_mark_all_read"
        get 'notifications'
        get 'sent'
        post 'custom_action(/:form_type)' => "messages#custom_action", as: :custom_action
        get 'trash'
        get 'message_popup'
        get 'new/:user_ids' => "messages#new", as: :new
        post 'reply_message'

      end
    end

  end
  
  resources :bars do
    match "upgrade" => "bars/payment_gateway#index", as: "upgrade"
  end

  namespace :users do
    match  "invite_friend" => "dashboard#after_join_invite_friends_by_email", as: "after_join_invite_friends_by_email"
    match  "invite_friends" => "dashboard#after_join_invite_friends_by_fb", as: "after_join_invite_friends_by_fb"
    post  "invite_friend_by_email" => "dashboard#after_sign_up_invite_friend_by_email", as: "after_sign_up_invite_friend_by_email"
    post  "invite_friend_by_fb" => "dashboard#after_sign_up_invite_friend_by_fb", as: "after_sign_up_invite_friend_by_fb"
    post  "update_user_for_mobile" => "dashboard#update_user_for_mobile", as: "update_user_for_mobile"
    match  "completion" => "dashboard#completion", as: "completion"
    post  "update_completion" => "dashboard#update_completion", as: "update_completion"
    match  "notifications" => "notifications#index", as: "notifications"
    match  "user_dashboard" => "dashboard#index", as: "dashboard"
    match  "facebook_dashboard" => "dashboard#facebook_page", as: "facebook_page"
    match  "facebook_mobile_profile" => "dashboard#facebook_mobile_profile", as: "facebook_mobile_profile"
    match  "facebook_update_status" => "dashboard#facebook_update_status", as: "facebook_update_status"
    match  "invite_swigbig" => "dashboard#invite_swigbig", as: "invite_swigbig"
    post "invite_by_email" => "dashboard#invite_by_email", as: :invite_by_email
    match  "profile/:id" => "dashboard#show", as: "profile"
    match  "rewards" => "dashboard#rewards", as: "rewards"
    match  "update_account" => "dashboard#update_account", as: "update_account"
    match  "update_password" => "dashboard#update_password", as: "update_password"
    #    get "bar_swigs/show"
    get  "show_swig/:bar_id/:swig_id" => "bar_swigs#show_swig", as: "show_swig"
    post  "enter_bar/:bar_id" => "bar_swigs#enter_bar", as: "enter_bar"
    post  "redeem/:bar_id" => "bars#redeem_reward", as: "redeem_reward"
    post "create_popularity/:bar_id" => "bars#create_popularity", as: "create_popularity"
    #--- friendship
    match "friendship" => "friends#index", as: "friend_index"
    post "friend_request/:id" => "friends#friend_request", as: "friend_request"
    post "remove_friend/:id" => "friends#remove_friend", as: :remove_friend
    post "approve_friend/:id" => "friends#approve_friend", as: :approve_friend
    get  "swiger_list/:bar_id" => "bars#swiger_list", as: "swiger_list"
    get  "mobile_reward" => "dashboard#mobile_reward", as: "mobile_reward"
    get  "lock_post_event" => "dashboard#lock_post_event", as: "lock_post_event"
    get  "unlock_post_event" => "dashboard#unlock_post_event", as: "unlock_post_event"
    get  "lock_post_to_swigbig_unlock" => "dashboard#lock_post_to_swigbig_unlock", as: "lock_post_to_swigbig_unlock"
    get  "unlock_post_to_swigbig_unlock" => "dashboard#unlock_post_to_swigbig_unlock", as: "unlock_post_to_swigbig_unlock"
    get  "bar_profile/:bar_id" => "bars#profile", as: "bar_profile"
    get  "sign_out_for_mobile" => "dashboard#sign_out_for_mobile", as: "sign_out_for_mobile"
    get  "convert_facebook_account_to_email_account" => "dashboard#convert_facebook_account_to_email_account", as: "convert_facebook_account_to_email_account"
    post  "mobile_invite_friends_by_email/:bar_id" => "dashboard#mobile_invite_friend_by_email", as: "mobile_invite_friend_by_email"
    get  "mobile_invite_friends/:bar_id" => "dashboard#mobile_invite_friends", as: "mobile_invite_friends"
    get  "notify_mark_as_read" => "dashboard#notify_mark_as_read", as: "notify_mark_as_read"

    match  "mobile_swigging/:bar_id" => "bar_swigs#mobile_swigging", as: "mobile_swigging"
    get  "mobile_invite_fb_friends/:bar_id" => "bar_swigs#mobile_invite_fb_friends", as: "mobile_invite_fb_friends"
    get  "mobile_invite_email_friends/:bar_id" => "bar_swigs#mobile_invite_email_friends", as: "mobile_invite_email_friends"
    post  "invite_fb_friends/:bar_id" => "bar_swigs#invite_fb_friends", as: "invite_fb_friends"
    post  "invite_email_friends/:bar_id" => "bar_swigs#invite_email_friends", as: "invite_email_friends"

    post  "update_profile" => "dashboard#update_profile", as: "update_profile"

    resources :messages do
      collection do
        get  "notify_mark_all_read" => "messages#notify_mark_all_read", as: "notify_mark_all_read"
        get  "messages_mark_all_read" => "messages#messages_mark_all_read", as: "messages_mark_all_read"
        get 'notifications'
        get 'sent'
        post 'custom_action(/:form_type)' => "messages#custom_action", as: :custom_action
        get 'trash'
        get 'new(/:bar_id)' => "messages#new", as: :new
      end
    end
  end

  #  devise_for :users, :controllers => {:sessions => "api/v1/mobiles"}
  namespace :api do
    namespace :v1 do
      resource :swig_mobiles do
        post 'register', 'home', 'bar_swigs', 'swig_bar', 'update_user'
        get 'get_lat_lon', 'swigbig_mobile', 'get_map', 'swig_list', 'reward_list'
      end
    end
  end

  devise_for :users, :controllers => {:sessions => "api/v1/mobiles"}

  devise_scope :user do
    get "api/v1/user/login", :to => "api/v1/mobiles#create"
    post "api/v1/user/login", :to => "api/v1/mobiles#create"
    get "api/v1/user/logout", :to => "api/v1/mobiles#destroy"
  end

  match "failure",  to: "api/v1/mobiles#failure", via: :get

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
