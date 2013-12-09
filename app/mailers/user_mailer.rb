class UserMailer < ActionMailer::Base
  @admin_email = ENV['ADMIN_EMAIL']
  default from: @admin_email

  def customer_confirmation_email(customer)
    @customer_id = customer.id
    @customer_email = customer.email
    @start_date = customer.start_date
    @interval = customer.interval
    @amount = customer.amount

    mail(to: @customer_email, subject: "Haute Toppings Membership Confirmation")
  end

  def admin_notification_email(customer, customer_name, customer_email)
    @customer_id = customer.id
    @customer_name = customer.name
    @customer_email = customer.email
    @interval = customer.interval
    @admin_internal_email = ENV['ADMIN_INTERNAL_EMAIL']
    
    mail(to: @admin_internal_email, subject: "NEW MEMBER: " + @customer_name)
  end
end
