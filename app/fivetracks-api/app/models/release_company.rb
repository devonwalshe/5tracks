class ReleaseCompany < ApplicationRecord
  # Set Tablename
  self.table_name = "release_company"
  
  # Relationships
  belongs_to :label, class_name: "Label", foreign_key: 'company_id'
  belongs_to :release
end
