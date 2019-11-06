class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
validates :name,length: {maximum: 50},  presence: true
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: {with: VALID_EMAIL_REGEX},uniqueness: true, length: {maximum: 255}, presence: true
has_secure_password
validates :password, length: {minimum: 6}, presence: true, allow_nil: true
  has_many :microposts, dependent: :destroy #множественное число потомуч то так всегда в has_many. Говорит, что если юзер будет удален, то и зависимые микропосты будут удалены
has_many :active_relationships,#юзер имеет много связей
         class_name: "Relationship",#определенных в модели релайшешшипс
         foreign_key: "follower_id",#внешний ключ фолловер ид(ключ поступаютщий из юзер запрос)(отслеживает кто? follower_id(фикс) отслеживает кого? множество индексов столбца followed_id)
         dependent: :destroy#при удалении юзера удалять и фоловерство
  has_many :following, through: :active_relationships, source: :followed#юзер имеет много фоловеров, которые определяются(ищутся) через модель active_relationships
  #причем источником массива following является набор followed идентификаторов
  #те из модели(таблицы) юзера берется айди, пихается в актив_релатионшипс, ищуются соответсвия в folloded_id(переменная followed), забираются идексы кого нашли
  # и перебрасываемся в модель(таблицу) user.following где по найденным индексам сопоставляются информация о юзерах
  # Follows a user.
  has_many :passive_relationships, class_name:  "Relationship",
           foreign_key: "followed_id",#в обратную сторону: отслеживают кого? фикс followed_id отслеживают кто? иножество индексов follower_id
           dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower#имеет много фоловеров, которые определяются из followerя
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end




  def feed#добавляем фид чтобы видеть все микропосты юзера на его странице
   #where выбирает по данному юзеру, ? гарантирует что id правильно экранируется
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)

  end

  def activate
   update_columns(activated: true, activated_at: Time.zone.now )
 end

  def password_reset_expired?#проверка не устарела ли ссылка на восстановление пароля из password_resets_controller
    reset_sent_at < 2.hours.ago#reset_sent_at лежит в бд юзера в add_reset_to_users и создается при клике на
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest#переход в данный метод из password_reset#create
    self.reset_token = User.new_token#self- переменная данного класса(определена в attr_acessor) генериться новый токен
    update_attribute(:reset_digest, User.digest(reset_token))#изменяем атрибут reset_digest в соответствии с токеном(те генерим новый пароль временный?)
    update_attribute(:reset_sent_at, Time.zone.now)#обновляем время изменения пароля
  end

  def send_password_reset_email#переход в данный метод из password_reset#create
    UserMailer.password_reset(self).deliver_now#переход в мэйлер User_Mailer метод password_reset где (self) это наш юзер из базы данных
  end

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
