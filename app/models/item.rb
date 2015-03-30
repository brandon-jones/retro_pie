class Item < ActiveRecord::Base
	validates :title, :description, :cost, :category, :markup, presence: true
	
	before_save :correct_format
	
	belongs_to :category

  monetize :cost_cents

  def self.has_base?(items)
  	items.each do |item|
  		return true if item.base_item
  	end
  	return false
  end

  def self.service_charge
  	# category = 
  	category = Category.find_or_create_by(name: 'Serivce Charge')
  	return Item.new(title: 'Service Charge', description: 'This is my serivce for setting it up. You can not remove this.', cost: $service_charge * 100, base_item: true, category_id: category.id)
  end

	def correct_format
		if self.markup.include?('$') || self.markup.include?('%') || self.markup.include?('x')
			return true
		end
		self.errors.add(:markup, "markup does not contain required characters")
		return false
	end

	def self.scrape_data(params)
		return_hash = {}

		unless params
			return_hash["error"] = "url emptry"
			return return_hash
		end

		begin
			response = RestClient.get params["item_amazon_url"]
			body = Nokogiri::HTML(response)
		rescue
			return_hash["error"] = "CAN NOT HIT #{params}"
		end

		unless body
			return_hash["error"] = "Unable to hit site"
			return
		end

		return_hash["title"] = body.css(params["title_css"]).text
		return_hash["description"] = body.css(params["description_css"]).css('li').collect { |li| li.text + "\n" }.join()
		return_hash["image_url"] = body.css(params["image_url_css"]).first["src"] if body.css(params["image_url_css"]) && body.css(params["image_url_css"]).count > 0
		return_hash["cost"] = body.css(params["cost_css"]).text.gsub('$','')
		return_hash["error"] = "Info scrapped from site"
		body.css('bucket normal').text
		return return_hash
	end
end
