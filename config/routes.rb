Devops::Application.routes.draw do
  devise_for :users

  resources :project, :except => [ :index ]
  resources :invoice
  resources :client,  :except => [ :index ]
  match '/i/:invoice_key',      :to => "invoice#show",  :as => "invoice"
  match '/s/:invoice_key',      :to => "invoice#send_invoice",  :as => "send_invoice"
  match '/invoice/:invoice_key',:to => "invoice#edit",  :as => "invoice_edit"
  match '/p/:project_id',       :to => "project#edit",  :as => "project_edit"
  match '/about',               :to => "about#index",   :as => "about"
  match '/dashboard',           :to => "index#index",   :as => "dashboard" 
  root :to => "index#index", :as => "dashboard"
end
