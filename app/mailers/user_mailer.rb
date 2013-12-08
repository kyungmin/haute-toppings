class UserMailer < ActionMailer::Base
  @admin_email = ENV['ADMIN_EMAIL']
  default from: @admin_email

  def customer_confirmation_email(customer_id, customer_email)
    @customer_id = customer_id
    @customer_email = customer_email
    mail(to: @customer_email, subject: "Haute Toppings Membership Confirmation")
  end

  def admin_notification_email(customer_id, customer_name, customer_email)
    @customer_id = customer_id 
    @customer_name = customer_name
    @customer_email = customer_email
    @admin_internal_email = ENV['ADMIN_INTERNAL_EMAIL']
    
    mail(to: @admin_internal_email, subject: "NEW MEMBER: " + @customer_name)
  end
end
