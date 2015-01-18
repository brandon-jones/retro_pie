class EmailedReceiptMailer < ActionMailer::Base
  default from: "bounder.mail@gmail.com"

  def emailed_receipt_send_mail(user)
  	@user = user
  	@receipt = true
    mail(to: @user.email, subject: "Thanks for your PIe order!")
  end

end