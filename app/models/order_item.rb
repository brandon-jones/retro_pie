class OrderItem < ActiveRecord::Base
	belongs_to :order

  monetize :item_price_cents

	def item
		return Item.where(id: item_id).first
	end
end
