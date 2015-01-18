class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate
  	authenticate_or_request_with_http_basic do |username, password|
	    if(username == ENV["RP_NAME"] && password == ENV["RP_PASSWORD"])
	      true
	    else
	      redirect_to root_path
	    end
  	end
	end

	def session_auth
		if ses = session["_bmp_#{params['controller'].singularize}_id".to_sym]
			if table = params['controller'].singularize.capitalize
				if params["id"].is_a? Integer
					if valid_results = table.constantize.find_by_id(params["id"])
						return true if valid_results
					end
				else
					if valid_results = table.constantize.find_by_order_id(params["id"])
						return true if valid_results
					end
				end
			end
		else
			authenticate
		end	
	end

	def param(name)
		if session["_bmp_#{name.to_sym}"]
			return session["_bmp_#{name.to_sym}"]
		elsif params[name]
			return params[name]
		end
		return nil
	end

end
