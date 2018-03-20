class ReleaseArtist < ApplicationRecord
  # Set Tablename
  self.table_name = "release_artist"
  
  # Relationships
  belongs_to :release
  belongs_to :artist
end
