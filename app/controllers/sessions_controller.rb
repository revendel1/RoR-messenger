class SessionsController < ApplicationController
  def new
  end

  def create
    # Если пользователь вводит правильные логин и пароль, то система его авторизует и запоминает егo id
    user = User.find_by_login(params[:login])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now[:alert] = "Username or password is invalid"
      render "new"
    end
  end

  def destroy
    # Когда пользователь выходит из системы, информация о нем обнуляется
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
