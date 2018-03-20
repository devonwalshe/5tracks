class ReleaseLabel < ApplicationRecord
  # Set Tablename
  self.table_name = "release_label"
  
  # Relationships
  belongs_to :label
  belongs_to :release
end
