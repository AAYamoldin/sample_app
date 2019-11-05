class CreateMicroposts < ActiveRecord::Migration[6.0]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]#захотим отображать микропосты выбранного пользователя в обратном порядке их создания
    #так что добавляем индексы в :user_id & :created_at столбцы для более быстрого поиска в Active Record
  end
end
