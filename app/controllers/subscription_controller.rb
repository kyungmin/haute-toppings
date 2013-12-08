require 'json'
require 'stripe'
Stripe.api_key = ENV["STRIPE_API_KEY"]

class SubscriptionController < ApplicationController
  def index
    render :index
  end

  def subscribe
    begin
      customer_name = "#{params[:first_name]} #{params[:last_name]}"
      customer_email = params[:email]

      stripe_customer = Stripe::Customer.create(
        :card => params[:stripeToken],
        :plan => params[:plan],
        :email => customer_email
      )
      fail
      subscribe_shopify_customer

      UserMailer.customer_confirmation_email(stripe_customer, customer_email).deliver
      UserMailer.admin_notification_email(stripe_customer, customer_name, customer_email).deliver

      customer_detail = {
        :id => stripe_customer.id,
        :start_date => Time.at(stripe_customer.subscription.start).strftime("%d/%m/%Y"),
        :amount => (stripe_customer.subscription.plan.amount / 100).to_f,
        :interval => stripe_customer.subscription.plan.interval
      }
      binding.pry
      render :json => customer_detail.to_json
    rescue Stripe::CardError => e
      render :json => { "error" => e }
    end
  end

  private

  def subscribe_shopify_customer
    ShopifyAPI::Base.site = "https://" + ENV['SHOPIFY_API_KEY'] + ":" + ENV['SHOPIFY_PASSWORD'] + "@haute-toppings.myshopify.com/admin"
    user = ShopifyAPI::Customer.find(params[:id])

    user.update_attributes({"tags" => "Wholesaler"})

    if (params[:accepts_marketing] == "on")
      user.update_attributes({"accepts_marketing" => true})
    end
  end
end

