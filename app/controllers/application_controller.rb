class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def authenticate
  	authenticate_or_request_with_http_basic do |username, password|
	    if(username == ENV["RP_NAME"] && password == ENV["RP_PASSWORD"])
	      true
	    else
	      redirect_to root_path
	    end
  	end
	end
end
