class ApplicationController < ActionController::Base
  before_action :authenticate_user

  def authenticate_user
    unless current_user
      redirect_to root_path
    end
  end

  def current_user
    return unless session[:current_user]

    @current_user ||= User.find_by(session_token: session[:current_user])
  end

  helper_method :current_user
end
