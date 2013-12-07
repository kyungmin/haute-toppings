require 'stripe'
Stripe.api_key = ENV["STRIPE_API_KEY"]

class SubscriptionController < ApplicationController
  def subscribe
    begin
      customer = Stripe::Customer.create(
        :card => params[:stripeToken],
        :plan => params[:plan],
        :email => params[:email]
      )
      UserMailer.customer_confirmation_email(params[:email]).deliver
      UserMailer.admin_notification_email(params[:email]).deliver
      render :json => customer
    rescue Stripe::CardError => e
      render :json => { "error" => e }
    end

  #   save_stripe_customer_id(user, customer.id)

  #   @subscription = Subscription.new(params[:subscription])
  #   if @subscription.save_with_payment
  #     render :json => @subscription
  #   else
  #     render :json => @subscription.errors.full_messages
  #   end    
  end

  def is_subscribed
    save_stripe_customer_id(user, customer.id)

    @subscription = Subscription.new(params[:subscription])
    if @subscription.save_with_payment
      render :json => @subscription
    else
      render :json => @subscription.errors.full_messages
    end    
  end

end

