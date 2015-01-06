json.array!(@orders) do |order|
  json.extract! order, :id, :item_id, :item_price, :item_count, :status, :name, :email, :perferred_contact, :shipping_info, :delivery_type, :shipping_price, :order_id, :special_instructions
  json.url order_url(order, format: :json)
end
