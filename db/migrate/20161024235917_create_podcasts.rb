class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.datetime :feature_date
      t.integer :type_id
      t.string :show
      t.text :episode
      t.text :link
      t.text :description
      t.string :genre
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
