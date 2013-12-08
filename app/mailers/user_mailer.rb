class UserMailer < ActionMailer::Base
  @admin_email = ENV['ADMIN_EMAIL']
  default from: @admin_email

  def customer_confirmation_email(customer, customer_email)
    @customer_id = customer.id
    @customer_email = customer_email
    @start_date = Time.at(customer.subscription.start).strftime("%d/%m/%Y")
    @interval = customer.subscription.plan.interval
    @amount = (customer.subscription.plan.amount / 100).to_f
    mail(to: @customer_email, subject: "Haute Toppings Membership Confirmation")
  end

  def admin_notification_email(customer, customer_name, customer_email)
    @customer_id = customer.id
    @customer_name = customer_name
    @customer_email = customer_email
    @admin_internal_email = ENV['ADMIN_INTERNAL_EMAIL']
    @interval = customer.subscription.plan.interval
    mail(to: @admin_internal_email, subject: "NEW MEMBER: " + @customer_name)
  end
end
