class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image#микропосту соответсвует один параметр из ()image) из Active storage базы данных
  default_scope -> {order(created_at: :desc)}#указываем на порядок вызывания постов из бд. по снизходящей для столбца created_at
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],#валидация с помощью гема active_storage_validation
                                      message: "must be a valid image format" },
            size:         { less_than: 5.megabytes,
                            message:   "should be less than 5MB" }

  # Returns a resized image for display.
  def display_image#использование гемов image_processing and mini_magic
    image.variant(resize_to_limit: [500, 500])
  end

end
