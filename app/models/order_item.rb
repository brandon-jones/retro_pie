class OrderItem < ActiveRecord::Base
	belongs_to :order

	def item
		return Item.where(id: item_id).first
	end
end
