class Category < ActiveRecord::Base
	has_many :items

	def self.has_base?(cat)
  	if category = Category.find_by_name(cat)
  		return Item.has_base?(category.items)
  	end
  	return true
  end
end
