class SessionsController < ApplicationController
  skip_before_action :authenticate_user
  def create
    payload = JWT.decode(params[:token], ENV['CHASM_OTP_SECRET'], 'HS256')[0]
    puts payload
    user = User.find_by(email: payload['email'])
    return if user.nil?

    user.update(verified: true, session_token: payload['secret'])
    session[:current_user] = payload['secret']

    redirect_to user_path(user)
  end

  def destroy
    session[:current_user] = nil
    redirect_to root_path
  end
end