class UserAuthenticationController < ApplicationController
  before_action :redirect_if_logged_in, only: [ :show, :create, :login_code ]

  def create
    user = User.find_or_initialize_by(user_params)
    if user.valid?
      user.set_login_code
      UserMailer.login_code_email(user).deliver_now
      session[:signed_id] = user.signed_id(expires_in: 15.minutes)
      redirect_to user_login_code_path
    else
      redirect_to user_authentication_path
    end
  end

  def login_code
    @user = User.find_signed(session[:signed_id])
  end

  def verify_login_code
    @user = User.find_signed(session[:signed_id])
    if @user.authenticate_login_code(params.dig(:login_code, :login_code))
      session[:signed_id] = nil
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      redirect_to user_login_code_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to user_authentication_path
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
