class Order < ActiveRecord::Base
	attr_accessor :items
	after_initialize :set_defaults
	has_many :order_items, dependent: :destroy
	has_many :payments
	belongs_to :user
 	# after_save :update_total
  monetize :total_cents, :cost_cents, :shipping_price_cents

  def refigure_totals
  	cost = 0
  	total = 0
  	OrderItem.where(order_id: self.id).each do |item|
  		cost += ( item.cost_cents * item.quantity)
  		total += ( item.price_cents * item.quantity)
  	end
  	self.update_attributes(cost_cents: cost, total_cents: total)
  end

	def local_shipping
		if self.delivery_type && self.delivery_type.present?
			return true if (self.shipping_info && self.shipping_info.present?) || (self.delivery_type == 'local_pickup')
		end
		return false
	end

	def status
		 return Status.find(self.status_id)
	end

	def set_defaults
		self.status_id = Status.all.where(name: 'Unsubmitted').first.id unless self.status_id || Status.all.length < 1
		self.order_id = SecureRandom.hex(6) unless self.order_id
		self.shipping_price = 0 unless self.shipping_price
	end

	def order_items_builder(user_items)
		final_items = []
		user_items.keys.each do |category|
			user_items[category].keys.each do |item_id|
				if user_items[category][item_id].keys.include?('ordered')
					final_items.push({item_id: item_id, quantity: user_items[category][item_id]["quantity"]})
				end
			end
		end
		create_order_items(final_items)
	end

	def calculate_cost
		return stats[1]
	end

	def stats
		item_total = 0
		item_cost = 0
		self.order_items.each do |item|
			item_total += item.price.to_f
			item_cost += item.cost.to_f
		end
		return item_total, item_cost
	end

	def has_details?
		return true if self.shipping_info.length > 0
		return true if self.special_instructions.length > 0
		return false
	end

	# def ordered_items(category_items)
	# 	binding.pry
	# 	base_item = []
	# 	ordered_items = []
	# 	category_items.keys.each do |key|
	# 		category_items[key]['item_id'] = key
	# 		base_item << category_items[key] if category_items[key].values.include?('true')
	# 		ordered_items << category_items[key] if category_items[key].keys.include?('ordered')
	# 	end
	# 	if base_item.count > 0
	# 		return base_item - ordered_items
	# 	else
	# 		return ordered_items - base_item
	# 	end
	# end

	def create_order_items(items)
		items.each do |item|
			db_item = Item.where(id: item[:item_id]).first

			if oi = OrderItem.where(order_id: self.id, item_id: item[:item_id]).first
				oi.quantity = item[:quantity]
			else
				oi = OrderItem.new(item_id: item[:item_id], quantity: item[:quantity], price: db_item.figure_price, cost: db_item.cost, order_id: self.id)
			end
			oi.save
		end
	end

	def verify_price(their_price, my_price)
		return true if their_price == my_price
		return false
	end

end
