class UserMailer < ActionMailer::Base
  @admin_email = ENV['ADMIN_EMAIL']
  default from: @admin_email

  def subscription_confirmation_customer(customer)
    @customer_id = customer[:id]
    @customer_name = customer[:name]
    @customer_email = customer[:email]
    @start_date = customer[:start_date]
    @interval = customer[:interval]
    @amount = customer[:amount]
    @admin_email = ENV['ADMIN_EMAIL']

    mail(to: @customer_email, bcc: @admin_email, subject: "Haute Toppings Membership Confirmation")
  end

  def subscription_confirmation_admin(customer)
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

  def cancellation_confirmation_customer(customer)
    @customer_name = customer[:name]
    @customer_email = customer[:email]
    @admin_internal_email = ENV['ADMIN_INTERNAL_EMAIL']
    @admin_email = ENV['ADMIN_EMAIL']

    mail(to: @customer_email, bcc: @admin_email, subject: "Cancellation Request Confirmation")
  end

  def cancellation_confirmation_admin(customer)
    @customer_name = customer[:name]
    @customer_email = customer[:email]
    @last_four = customer[:last_four]
    @date_requested = Time.current.to_date
    @reason = customer[:reason].join(", ").chop
    @suggestion = customer[:suggestion]
    @admin_internal_email = ENV['ADMIN_INTERNAL_EMAIL']

    mail(to: @admin_internal_email, subject: "CANCELLATION REQUEST: #{@date_requested} / #{@customer_email}")
  end
end
