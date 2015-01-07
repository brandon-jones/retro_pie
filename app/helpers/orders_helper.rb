module OrdersHelper

	def figure_increase_cost(this_category,this_price)
		cat_id = Category.where(name: this_category).first.id
		if base_item = Item.where(category_id: cat_id, base_item: true).first
			base_price = base_item.markup.gsub('$','').to_i
		end
		this_price = this_price.gsub('$','').to_i
		if base_price && this_price
			new_price = this_price - base_price
			return 'included' if new_price == 0
			return "$#{this_price}"
		end
		return "$#{this_price}"
	end

	def quantity_selector(item)
		if item.category.name == "Controller"
			if item.base_item
				return "<select class='dropdown-price-changer price-changer'><option value='1'>1</option><option value='2'>2 +#{item.markup}</option></select>"
			else
				return "<select class='dropdown-price-changer price-changer'><option value='1'>1</option><option value='2'>2</option></select>"
			end
		else
			return 	"<select class='dropdown-price-changer price-changer'><option value='1'>1</option></select>"
		end

	end


end
