StripeShopify::Application.routes.draw do
  root :to => "subscription#index"
  post "subscribe" => "subscription#subscribe"
  get "subscribe" => "subscription#subscribe"
end
