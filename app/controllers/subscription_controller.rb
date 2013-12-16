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
      membership_type = (params[:membership_type] == "month" ? "Membership" : "Membership (Yearly)")

      stripe_customer = Stripe::Customer.create(
        :card => params[:stripeToken],
        :plan => membership_type,
        :email => customer_email
      )

      customer_detail = {
        :id => stripe_customer.id,
        :name => customer_name,
        :email => customer_email,
        :start_date => Time.at(stripe_customer.subscription.start).strftime("%m/%d/%Y"),
        :amount => "%.2f" % (stripe_customer.subscription.plan.amount.to_f / 100.to_f),
        :interval => stripe_customer.subscription.plan.interval,
        :referral_code => params[:referral_code] || 'None'
      }

      subscribe_shopify_customer

      UserMailer.subscription_confirmation_customer(customer_detail).deliver
      UserMailer.subscription_confirmation_admin(customer_detail).deliver

      render :json => customer_detail.to_json
    rescue Stripe::CardError => e
      render :json => { "error" => e }
    end
  end

  def cancel
    customer_detail = {
      :name => params[:name],
      :email => params[:email],
      :reason => params[:reason],
      :suggestion => params[:suggestion]
    }

    UserMailer.cancellation_confirmation_customer(customer_detail).deliver
    UserMailer.cancellation_confirmation_admin(customer_detail).deliver

    render :json => customer_detail
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

