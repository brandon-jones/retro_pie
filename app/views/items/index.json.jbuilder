json.array!(@items) do |item|
  json.extract! item, :id, :title, :description, :amazon_url, :image_url, :price, :base_item, :category_id
  json.url item_url(item, format: :json)
end
