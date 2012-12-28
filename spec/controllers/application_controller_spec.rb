require 'spec_helper'

describe ApplicationController, '#logged_in?' do
  it 'returns false if the user has not been cookied' do
    controller.should_not be_logged_in
  end

  it 'returns true if the user has been cookied' do
    cookies[:user_id] = 1

    controller.should be_logged_in
  end
end

describe ApplicationController, '#login_user' do
  it 'stores the new user id in a cookie' do
    user = stub :id => 5

    expect {
      controller.login_user(user)
    }.to change{ cookies[:user_id] }.from(nil).to(5)
  end
end

describe ApplicationController, '#authenticate_user' do
  it 'doesnt create a new user if already logged in' do
    controller.stub :logged_in? => true

    expect {
      controller.send :authenticate_user
    }.to_not change(User, :count)
  end

  it 'creates a new user if not logged in' do
    expect {
      controller.send :authenticate_user
    }.to change(User, :count).by(1)
  end

  it 'logs the newly created user in' do
    expect {
      controller.send :authenticate_user
    }.to change(controller, :logged_in?).from(false).to(true)
  end
end
