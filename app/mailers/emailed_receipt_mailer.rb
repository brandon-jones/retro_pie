class EmailedReceiptMailer < ActionMailer::Base
  default from: "bounder.mail@gmail.com"

  def emailed_receipt_send_mail(user, order_id = nil)
  	@user = user
  	@receipt = true
  	if order_id
  		@orders = Order.find_by_order_id(order_id)
  		if @orders
  			@orders = [@orders]
  		else
  			@orders = []
  		end
  	else
  		@orders.user.orders
  	end
    mail(to: @user.email, subject: "Thanks for your PIe order!")
  end

end