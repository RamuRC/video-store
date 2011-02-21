Rails.application.routes.draw do
  resources :orders do
    post :populate, :on => :collection
    resources :line_items
    resources :creditcards
    resources :creditcard_payments
  end

  resources :products do
    get :watch_now, :on => :member
    get :get_xml, :on => :member
  end
end
