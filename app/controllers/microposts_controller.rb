class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)#в соответсвии с таблицей 13.1 возвращает объект ассоциированный с юхером
    #в нашем случае это залогиненый current_user который определен в хэлпере сессий
    @micropost.image.attach(params[:micropost][:image])#мы здесь юзаем метод attach который нам предоставил Active Storage который прикрепляет
    #подгурежный имадж к микропосту (не забудь обновить метод разрешающий загрузку!)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url#проходит цепочку контроллер/вьюха статик педжс/хоум
    else
      @feed_items = current_user.feed.paginate(page: params[:page])#если микропост не прошел валидацию, то вызывается обновление страницы и перемененная @feed_items получается не определена
      #при рендере не запускается контроллер, а подгружается только вьха?
      render 'static_pages/home'#рендер сохраняет информацию POST запроса в отличии от редиректа
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url#request.referrer переход через контроллер и вьюху на предыдущий урл адресс

  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)#контент это параметр определенный в бд для микропоста как текст этого микропоста
  end#добавили переменную имадж чтобы разрешетить загрузку его в микропост

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])#проверка что у current_usera есть данный микропост
    redirect_to root_url if @micropost.nil?
  end
end