module ApplicationHelper
	def all_params
		binding.pry
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
