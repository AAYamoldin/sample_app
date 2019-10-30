class PasswordResetsController < ApplicationController
before_action :get_user,         only: [:edit, :update]
before_action :valid_user,       only: [:edit, :update]
before_action :check_expiration, only: [:edit, :update]    # Case (1)

def new #переход в данный метод из формы sessions.new подгруз вьюхи с аналогичным названием но уже из password_resets.new тк название котроллера
end

#создание ссылки восстановления
def create#переход из вьюхи password_resets.new с параметром емейла
  @user = User.find_by(email: params[:password_reset][:email].downcase)#поиск юзера по емейлу из базы данных
  if @user#если существует
    @user.create_reset_digest#переход в модель юзера для подгружение метода create_reset_digest который
    @user.send_password_reset_email#отправка емейла юзеру
    flash[:info] = "Email sent with password reset instructions"
    redirect_to root_url#переброс в корневой путь(отправка запроса в браузер)
  else
    flash.now[:danger] = "Email address not found"
    render 'new'#вызываем новый шаблон(не сбрасываем форму)
  end
end
 #в отправленом емейле содержится ссылка edit_password_reset_url(token) в нашем случае это edit_password_reset_url(@user.reset_token, email: @user.email)
# (@user.reset_token) переменная определенная в моделе User как аттр.акцессор и генерится в create_reset_token
# данная ссылка срдержит в себе токен, а также при переходе вызывает edit метод в данном котроллере
  def edit#подгружает соответсвующую вьюху
end
#переход в данный метод из вьюхи edit со всеми данными внутренности формы
def update
  if params[:user][:password].empty?                  # Case (3)
    @user.errors.add(:password, "can't be empty")#проверка паспорта на пустоту
    render 'edit'#
  elsif @user.update(user_params)#встроенный метод рельсов update? с подгружением тех только тех параметров, которые хотим изменить # Case (4)
    log_in @user
    flash[:success] = "Password has been reset."
    redirect_to @user
  else
    render 'edit'                                     # Case (2)
  end
end

private

def user_params
  params.require(:user).permit(:password, :password_confirmation)
end

# Before filters

def get_user
  @user = User.find_by(email: params[:email])
end

# Confirms a valid user.
def valid_user#юзер сущесвет, активирован, имеет соотвествующий reset_digest, который мы ему присвоили в @User.create_reset_digest
  unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
  end
end

# Checks expiration of reset token.
def check_expiration
  if @user.password_reset_expired?
    flash[:danger] = "Password reset has expired."
    redirect_to new_password_reset_path#гет запрос переход в метод new в этом контроллере
  end
end
end