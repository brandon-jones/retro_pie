class Order < ActiveRecord::Base
	attr_accessor :items
	after_initialize :set_defaults
	has_many :order_items, dependent: :destroy
	has_many :payments
	belongs_to :user

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
		self.status_id = Status.all.where(name: 'Unsubmitted').first.id unless self.status_id
		self.order_id = SecureRandom.hex(12) unless self.order_id
		self.shipping_price = 0 unless self.shipping_price
	end

	def order_items_builder(user_items)
		user_items.keys.each do |categories|
			user_items[categories] = ordered_items(user_items[categories])
			create_order_items(user_items[categories])
		end

	end

	def calculate_cost
		return stats[1]
	end

	def stats
		item_total = 0
		item_cost = 0
		self.order_items.each do |item|
			item_total += item.item_price.to_f
			item_cost += item.item_cost.to_f
		end
		return item_total, item_cost
	end

	def has_details?
		return true if self.shipping_info.length > 0
		return true if self.special_instructions.length > 0
		return false
	end

	def ordered_items(category_items)
		base_item = []
		ordered_items = []
		category_items.keys.each do |key|
			category_items[key]['item_id'] = key
			base_item << category_items[key] if category_items[key].values.include?('true')
			ordered_items << category_items[key] if category_items[key].keys.include?('ordered')
		end
		if base_item.count > 0
			return base_item - ordered_items
		else
			return ordered_items - base_item
		end
	end

	def create_order_items(category_items)
		category_items.each do |item|
			db_item = Item.where(id: item["item_id"]).first
			# verify_price(item["price"],db_item.markup.gsub('$','').strip)
			if oi = OrderItem.where(order_id: self.id, item_id: item["item_id"]).first
				oi.quantity = item["quantity"]
			else
				oi = OrderItem.new(item_id: item["item_id"], quantity: item["quantity"], item_price: db_item.markup.gsub('$','').strip.to_i, item_cost: db_item.price, order_id: self.id)
			end
			oi.save
		end
	end

	def verify_price(their_price, my_price)
		return true if their_price == my_price
		return false
	end

end
