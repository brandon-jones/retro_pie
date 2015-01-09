json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :phone, :apt_number, :street, :city, :state, :zip_code
  json.url user_url(user, format: :json)
end
