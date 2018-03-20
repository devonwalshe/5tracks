class CreateSearchTrack < ActiveRecord::Migration[5.1]
  def change
    create_table :search_tracks do |t|
      t.integer :track_id
      t.integer :score
      t.integer :release_id
      t.text :artist_ids, array: true, default:[]
      t.string :title
      t.string :release_title
      t.string :artist_names
    end
  end
end
