class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :podcast, index: true
      t.references :user, index: true
      t.text :comment

      t.timestamps null: false
    end
    add_foreign_key :comments, :podcasts
    add_foreign_key :comments, :users
  end
end
