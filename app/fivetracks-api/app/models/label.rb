class Label < ApplicationRecord
  # Set Tablename
  self.table_name = "label"
  
  # Aliases
  alias_attribute :urls, :artist_urls
  alias_attribute :tracks, :release_tracks
  
  # Relationships
  has_many :label_urls
  has_many :release_labels
  has_many :releases, through: :release_labels
  has_many :release_artists, -> {where('extra':0)}, through: :releases
  has_many :release_tracks, through: :releases
  has_many :artists, -> {distinct}, through: :release_artists
  has_many :release_companies, foreign_key: :company_id
  has_many :sublabels, :class_name => "Label", foreign_key: :parent_name, primary_key: :name
  has_one :parent, :class_name => "Label", foreign_key: :name, primary_key: :parent_name
  
end
