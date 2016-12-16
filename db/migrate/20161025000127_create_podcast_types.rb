class CreatePodcastTypes < ActiveRecord::Migration
  def change
    create_table :podcast_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
