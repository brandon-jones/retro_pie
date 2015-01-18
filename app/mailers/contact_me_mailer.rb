class ContactMeMailer < ActionMailer::Base
  default from: "bounder.mail@gmail.com"

  def contact_me_send_mail(name, email, body)
    @name = name
    @email = email
    @body = body
    mail(to: "brandon@brjcoding.com", subject: "#{@name} has a question")
  end

end