class Master < ApplicationRecord
  # Set Tablename
  self.table_name = "master"
  
  # Aliases
  alias_attribute :genres, :master_genres
  alias_attribute :styles, :master_styles
  alias_attribute :videos, :master_videos
  
  # Relationships
  has_many :master_artists
  has_many :artists, through: :master_artists
  has_many :master_genres
  has_many :master_styles
  has_many :master_videos
  has_many :releases
  
end
