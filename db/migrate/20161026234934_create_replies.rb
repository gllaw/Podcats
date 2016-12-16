class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :user, index: true
      t.references :comment, index: true
      t.text :reply

      t.timestamps null: false
    end
    add_foreign_key :replies, :users
    add_foreign_key :replies, :comments
  end
end
