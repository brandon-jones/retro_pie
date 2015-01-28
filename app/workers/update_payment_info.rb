class UpdatePaymentInfo
	include Sidekiq::Worker

	def perform(params)
		puts 'TESTING TESTING TESTS'
		order = Order.find_by_order_id params["item_number"]
		payment = Payment.find_or_create_by(order_id: order.id)
		payment.amount = params["payment_gross"]
		payment.status = params["payment_status"]
		payment.meta = params.to_json
		payment.save
		puts 'testestead testestead TESTS'
	end
end