class ApplicationController < ActionController::Base
  before_filter :authenticate_user

  protect_from_forgery

  def logged_in?
    cookies[:user_id].present?
  end

  def login_user(user)
    cookies[:user_id] = user.id
  end

  def current_user
    User.where(id: cookies[:user_id]).first
  end

private

  def authenticate_user
    login_user(User.create_new) unless logged_in?
  end
end
