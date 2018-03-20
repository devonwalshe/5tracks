class Release < ApplicationRecord
  # Set Tablename
  self.table_name = "release"
  
  # Aliases
  alias_attribute :videos, :release_videos
  alias_attribute :tracks, :release_tracks
  alias_attribute :styles, :release_styles
  alias_attribute :identifiers, :release_identifiers
  alias_attribute :genres, :release_genres
  alias_attribute :formats, :release_formats
  alias_attribute :companies, :release_companies
  
  # Relationships
  has_many :release_videos
  has_many :release_tracks
  has_many :release_artists
  has_many :artists, through: :release_artists
  has_many :release_styles
  has_one :release_label
  has_one :label, through: :release_label
  has_many :release_identifiers
  has_many :release_genres
  has_many :release_formats
  has_many :release_companies
  has_many :release_tracks
  has_many :release_track_artists
  has_many :main_artists, -> {where('release_artist.extra': 0)}, through: :release_artists, source: :artist
  has_many :extra_artists, -> {where('release_artist.extra': 1)}, through: :release_artists, source: :artist
  
  
  def companies
    Label.includes(:release_companies).where('release_company.release_id': self.id)
  end
  
  # def main_artists
  #   Artist.joins(:release_artists).where('release_artist.release_id': self.id, 'release_artist.extra': 0).uniq
  # end
  
  def extra_artists
    Artist.joins(:release_artists).where('release_artist.release_id': self.id, 'release_artist.extra': 1).uniq
  end
  
  
end
