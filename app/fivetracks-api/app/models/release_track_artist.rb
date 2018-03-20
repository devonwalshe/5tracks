class ReleaseTrackArtist < ApplicationRecord
  # Set Tablename
  self.table_name = "release_track_artist"
  # Relationships
  belongs_to :release
  belongs_to :artist
  has_many :release_artists, foreign_key: :release_id
  belongs_to :release_track
end
