class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id#добввляем индексы для эффективности тк поиск будет проходить по фолловевр и фолловед
    add_index :relationships, :followed_id
    add_index :relationships, [:followed_id, :follower_id], unique: true#уникальность дает нам то, что один юзер не может отслеживать другого больше чем один раз
  end
end
