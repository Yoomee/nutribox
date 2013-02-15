Nutribox::Application.routes.draw do
  root :to => 'home#index'
  
  resources :orders, :except => [:destroy], :path => "subscriptions" do
    collection do
      get 'list'
    end
    member do
      get 'download'
      get 'thanks'
    end
  end
  
  resources :shipping_dates, :only => :show, :path => "shippings"
  
  resources :discount_codes
  
  resources :products
  match "products/:year/:month" => 'products#month', :as => 'products_month' 

  match "box/:box_type/:year/:month" => 'boxes#show', :as => 'box'
  match "boxes" => "boxes#latest", :as => 'latest_box'
  
  match "surveys/:year/:month/:box_type/preview" => 'surveys#preview', :as => 'survey_preview'
  match "surveys/:year/:month/results" => 'surveys#results', :as => 'survey_results'
  match "surveys/:year/:month/download" => 'surveys#download', :as => 'survey_download'
  match "surveys/:year/:month/recipients" => 'surveys#recipients', :as => 'survey_recipients'
  match "surveys/:year/:month/send_emails" => 'surveys#send_emails', :as => 'send_emails_survey'
  
  match 'newsletter/subscribe' => "newsletter#subscribe", :as => "subscribe_newsletter"
  
  resources :surveys
  
  match "rate/:product_id/:survey_hash/:rating" => 'survey_answers#rate', :as => 'survey_answer_rate'
  resources :survey_answers

  get  'join' => "orders#new"
  get  'gift' => "orders#new", :gift => 1
  post 'join' => "orders#create"
  post 'gift' => "orders#create"
  put 'join/:id' => "orders#update", :as => 'update_join'
  put 'gift/:id' => "orders#update", :as => 'update_gift'
  
  match "sign-up" => redirect("/login")
  

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
  # match ':controller(/:action(/:id(.:format)))'
end
