class Mailer < ActionMailer::Base

  layout 'mailer'

  default from: Settings.default_from_email

  default_url_options[:host] = Settings.host_for_email_with_www

  def dummy_mailer(send_to)
    mail(to: send_to, subject: 'Test Email') do |format|
      format.text
      format.html
    end
  end

end
