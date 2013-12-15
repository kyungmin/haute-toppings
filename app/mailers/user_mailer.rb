class UserMailer < ActionMailer::Base
  @admin_email = ENV['ADMIN_EMAIL']
  default from: @admin_email

  def customer_confirmation_email(customer)
    @customer_id = customer[:id]
    @customer_name = customer[:name]
    @customer_email = customer[:email]
    @start_date = customer[:start_date]
    @interval = customer[:interval]
    @amount = customer[:amount]
    @admin_email = ENV['ADMIN_EMAIL']

    mail(to: "#{@customer_email}; #{@admin_email}", subject: "Haute Toppings Membership Confirmation")
  end

  def admin_notification_email(customer)
    @customer_id = customer[:id]
    @customer_name = customer[:name]
    @customer_email = customer[:email]
    @start_date = customer[:start_date]
    @interval = customer[:interval]
    @referral_code = customer[:referral_code]
    @admin_internal_email = ENV['ADMIN_INTERNAL_EMAIL']

    @subject = "NEW MEMBER: #{@customer_name} / #{@customer_email}"
    @subject += " / #{@referral_code}" if @referral_code != "None"

    mail(to: @admin_internal_email, subject: @subject)
  end
end
