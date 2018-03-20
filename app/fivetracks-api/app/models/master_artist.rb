class MasterArtist < ApplicationRecord
  # Set Tablename
  self.table_name = "master_artist"
  
  # Relationshiops
  belongs_to :artist
  belongs_to :master
  
end
