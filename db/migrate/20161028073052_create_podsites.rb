class CreatePodsites < ActiveRecord::Migration
  def change
    create_table :podsites do |t|
      t.string :name
      t.string :url
      t.integer :site_type

      t.timestamps null: false
    end
  end
end
