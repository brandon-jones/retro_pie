class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def authenticate
  	authenticate_or_request_with_http_basic do |username, password|
	    if(username == ENV["RP_NAME"] && password == ENV["RP_PASSWORD"])
	    	session[:my_pie_override] = 
	      true
	    else
	      redirect_to root_path
	    end
  	end
	end

	def poor_auth
		if session[:my_pie_order]
			if session[:my_pie_order] == params["id"]
				order = Order.where(order_id: session[:my_pie_order]).first
				if order
					return true
				else
					return false
				end
			else
				return false
			end
		end
		authenticate_or_request_with_http_basic do |username, password|
			if order = Order.where(order_id: password).first
		    if(username == order.email && password == order.order_id)
		    	session[:my_pie_order] = order.order_id
		      return true
		   	end
		  end

	    if(username == ENV["RP_NAME"] && password == ENV["RP_PASSWORD"])
	    	return true
	    end
  	end
  	redirect_to root_path and return
	end

end
