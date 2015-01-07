class Order < ActiveRecord::Base
	validates_presence_of :name, :email, :perferred_contact
	validates_presence_of :shipping_info, unless: :local_shipping
	before_create :set_defaults
	has_many :order_items

	def local_shipping
		if self.delivery_type && self.delivery_type.present?
			return true if (self.shipping_info && self.shipping_info.present?) || (self.delivery_type == 'local_pickup')
		end
		return false
	end

	def status
		 return Status.find(self.status_id).name
	end

	def set_defaults
		self.status_id = Status.all.where(name: 'Unsubmitted').first.id
		self.order_id = self.name.gsub(' ','') + "-" + SecureRandom.hex(8)
		self.shipping_price = self.delivery_type == 'delivery' ? $shipping : 0
	end

	def order_items_builder(user_items)
		user_items.keys.each do |categories|
			user_items[categories] = ordered_items(user_items[categories])
			create_order_items(user_items[categories])
		end

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
			verify_price(item["price"],db_item.markup.gsub('$','').strip)
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
