StripeShopify::Application.routes.draw do
  post "subscribe" => "subscription#subscribe"
  get "is_subscribe" => "subscription#is_subscribed"
end
