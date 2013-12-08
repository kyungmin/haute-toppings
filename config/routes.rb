StripeShopify::Application.routes.draw do
  post "subscribe" => "subscription#subscribe"
  get "subscribe" => "subscription#subscribe"
end
