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

	def build_receipt_table(order_items)
		builder = "<table class='table'>
			  <tr>
			    <th>Category</th>
			    <th>Item Name</th> 
			    <th>Item Each Price</th>
			    <th>Quantity</th>
			    <th>Total</th>
			  </tr>"
		total = $base_price
		order_items.each do |order_item|
			item = Item.where(id: order_item.item_id).first
			total += order_item.item_price unless item.base_item
			# builder += "<strong>#{item.category.name}<br>"
			builder += "
			  <tr>
			    <td>#{item.category.name}</td>
			    <td>#{item.title}</td> 
			    <td>#{item.base_item ? 'included' : '$' + ('%.2f' % order_item.item_price)}</td>
			    <td>#{order_item.quantity}</td>
			    <td>#{item.base_item ? 'included' : '$' + ('%.2f' % (order_item.quantity * order_item.item_price))}</td>
			  </tr>"
		end

		builder += "<tr>
			    <td></td>
			    <td></td> 
			    <td></td>
			    <td></td>
			    <td></td>
			  </tr>"
		if @order.delivery_type == 'delivery'
			builder += "<tr>
				    <td></td>
				    <td></td> 
				    <td></td>
				    <td><strong>Shipping:</strong></td>
				    <td>$#{'%.2f' % @order.shipping_price.to_f}</td>
				  </tr>"
		end

		builder += "<tr>
			    <td></td>
			    <td></td> 
			    <td></td>
			    <td><strong>Total:</strong></td>
			    <td>$#{'%.2f' % @order.total.to_f}</td>
			  </tr>"


		builder += "</table>"

		return builder
	end

	def format_init_price
		if @order.total
			return "$#{'%.0f' % @order.total.to_f}"
		end
		return "$#{'%.0f' % $base_price}"
	end

end
