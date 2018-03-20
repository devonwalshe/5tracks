class ReleaseVideo < ApplicationRecord
  # Set Tablename
  self.table_name = "release_video"
  
  belongs_to :release
end
