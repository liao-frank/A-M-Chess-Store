class ApplicationController < ActionController::Base
	include ChessStoreHelpers::Cart

# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	rescue_from CanCan::AccessDenied do |exception|
	    flash[:error] = "You are not allowed to access that page."
	    redirect_to home_path
	end

	private
	def cart_count
		get_list_of_items_in_cart.length
	end
	helper_method :cart_count

	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	helper_method :current_user

	def logged_in?
		current_user
	end
	helper_method :logged_in?

	def check_login
		redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
	end

	def check_not_login
		redirect_to home_path, alert: "You are already logged in." if !current_user.nil?
	end

	def getGrandParam(ps)
		if ps.kind_of? Array

		else
			if params.has_key?(:parameters)
				parameters = parse_nested_query(params[:parameters])
				return parameters[ps]
			else
				return nil
			end
		end
	end
end
