module OrdersHelper

	def caret(current)
		if @sort_by == current
			if @sort_order == 'ASC'
				return '<i class="fa fa-caret-down"></i>'
			else
				return '<i class="fa fa-caret-up"></i>'
			end
		end
		return ''
	end

	def figure_increase_cost(this_category,this_price)
		cat_id = Category.where(name: this_category).first.id
		if base_item = Item.where(category_id: cat_id, base_item: true).first
			base_fee = base_item.markup.gsub('$','').to_i
		end
		this_price = this_price.gsub('$','').to_i
		if base_fee && this_price
			new_price = this_price - base_fee
			return "$#{this_price}"
		end
		return "$#{this_price}"
	end

	def quantity_selector(item)
		quantity = @order.order_items.where(item_id: item.id).first.quantity if @order.order_items.where(item_id: item.id).first
		builder = "<select class='dropdown-price-changer price-changer' name='order[items][#{item.category.name}][#{item.id}][quantity]'>"

		builder += "<option value='1' #{quantity==1?'selected':''}>1</option>"
		if item.category.name == "Controller"		
			if item.base_item
				builder += "<option value='2' #{quantity==2?'selected':''}>2 +#{item.markup}</option>"
			else
				builder += "<option value='2' #{quantity==2?'selected':''}>2</option>"
			end

		end
		
		return builder + "</select>"

	end

	def any_errors(name)
		return 'field_with_errors' if @order.errors.keys.include?(name.to_sym)
		return ''
	end

	def format_init_price
		if @order.total
			return "$#{'%.0f' % @order.total.to_f}"
		end
		return "$#{'%.0f' % $base_fee}"
	end

end
