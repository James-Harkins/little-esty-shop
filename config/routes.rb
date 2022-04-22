Rails.application.routes.draw do

  get '/', to: 'welcome#index'

  resources :merchants do
    get '/items', to: 'merchant_items#index'
    post '/items', to: 'merchant_items#create'
    get '/items/new', to: 'merchant_items#new'
    get '/items/:item_id/edit', to: 'merchant_items#edit'
    get '/items/:item_id', to: 'merchant_items#show'
    patch '/items/:item_id', to: 'merchant_items#update'
    delete '/items/:item_id', to: 'merchant_items#destroy'

    get '/invoices', to: 'merchant_invoices#index'
    post '/invoices', to: 'merchant_invoices#create'
    get '/invoices/new', to: 'merchant_invoices#new'
    get '/invoices/:invoice_id/edit', to: 'merchant_invoices#edit'
    get '/invoices/:invoice_id', to: 'merchant_invoices#show'
    patch '/invoices/:invoice_id', to: 'merchant_invoices#update'
    delete '/invoices/:invoice_id', to: 'merchant_invoices#destroy'

    get '/invoice_items', to: 'merchant_invoice_items#index'
    post '/invoice_items', to: 'merchant_invoice_items#create'
    get '/invoice_items/new', to: 'merchant_invoice_items#new'
    get '/invoice_items/:invoice_item_id/edit', to: 'merchant_invoice_items#edit'
    get '/invoice_items/:invoice_item_id', to: 'merchant_invoice_items#show'
    patch '/invoice_items/:invoice_item_id', to: 'merchant_invoice_items#update'
    delete '/invoice_items/:invoice_item_id', to: 'merchant_invoice_items#destroy'

    get '/discounts', to: 'merchant_discounts#index'
    post '/discounts', to: 'merchant_discounts#create'
    get '/discounts/new', to: 'merchant_discounts#new'
    get '/discounts/:id', to: 'merchant_discounts#show'
    delete 'discounts/:id', to: 'merchant_discounts#destroy'
  end

  get '/merchants/:id/dashboard', to: 'merchants#show'

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants
    resources :invoices, only: [:index, :show, :update]
  end
end
