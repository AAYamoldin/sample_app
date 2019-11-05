class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  #т.к. эта проверка нам нужна и для контролера юзера и для контролера микропостов, то выносим его сюда для избежания повторения кода
  # другими словами этот метод теперь доступен сразу в двух контролерах и мы можем с ним работать так, как будто он в каждои из них объявлен
    def logged_in_user
      unless logged_in? #Are u Current_user? /no! then go
        store_location
        flash[:danger] = "Please log in!"
        redirect_to login_path #go to session new
      end
    end
end
