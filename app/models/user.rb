class User < ActiveRecord::Base
	validates_presence_of :name, :email
  before_save :shipping_required

	# include BCrypt

  def shipping_required
    if self.delivery_type == 'delivery'
      binding.pry
    end
    return true
  end

	# def password
 #    @password ||= Password.new(password_hash)
 #  end

 #  def password=(new_password)
 #    @password = Password.create(new_password)
 #    self.password_digest = @password
 #  end

 #  def new_session_id
 #  	self.session_token_expiration = DateTime.now.utc + 24.hours
 #  	self.session_token = SecureRandom.hex(16)
 #  end

  def delivery_type
    return [['Pickup','pickup'],['Delivery','delivery']]
  end
end
