class UserMailer < ActionMailer::Base
  @admin_email = "kmin905@gmail.com"
  default from: @admin_email

  def customer_confirmation_email(email)
    @email = email
    mail(to: @email, subject: "Haute Toppings Membership Confirmation")
  end
  def admin_notification_email(email)
    @email = email
    mail(to: @admin_email, subject: "New Haute Toppings Membership")
  end
end
