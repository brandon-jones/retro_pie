class OrderItem < ActiveRecord::Base
	belongs_to :order

  monetize :price_cents
  monetize :cost_cents

	def item
		return Item.where(id: item_id).first
	end
end