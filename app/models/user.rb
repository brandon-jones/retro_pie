class User < ActiveRecord::Base
  attr_accessor :delivery_type
  validates_presence_of :name, :email
  validates_presence_of :street, :city, :state, :zip_code, :if => :shipping_required?
  has_many :orders

  # include BCrypt

  def shipping_required?
    if @delivery_type == 'delivery'
      return true
    end
    return false
  end

  # def orders
  #   return Order.where(user_id: self.id)]
  # end

  def delivery_types
    return [['Pickup','pickup'],['Delivery','delivery']]
  end
end
