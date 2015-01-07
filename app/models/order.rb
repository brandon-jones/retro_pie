class Order < ActiveRecord::Base
	validates_presence_of :name, :email, :perferred_contact
	validates_presence_of :shipping_info, unless: :local_shipping
	before_save :set_defaults
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
		self.shipping_price = self.shipping_info == 'local_pickup' ? 0 : 10
	end

end
