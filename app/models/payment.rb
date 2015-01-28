class Payment < ActiveRecord::Base
	belongs_to :order

	# after_initialize :set_defaults

	# def set_defaults
	# 	self.status = 'processing'
	# 	self.save
	# end

	def amount
		if self.status == 'pending' || self.status == nil
			self.order.total
		else
			return super
		end
	end
end