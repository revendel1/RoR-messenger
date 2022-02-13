class ApplicationController < ActionController::Base
    helper_method :current_user
    # метод, идентифицирующий вошедшего в систему пользователя
    def current_user
      return @current_user if @current_user.present?

      if session[:user_id].present?
        @current_user = User.find_by(id: session[:user_id])
      else
        @current_user = nil
      end

      cookies[:user_id] = session[:user_id]

      @current_user
    end

end
