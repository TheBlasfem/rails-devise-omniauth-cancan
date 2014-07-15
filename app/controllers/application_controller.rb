class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
		if current_user.nil? # user is not logged in
			redirect_to login_url, :alert => "Please log in to continue."
		else
			render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
		end
	end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:signin) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :username, :password, :password_confirmation) }
  end
end