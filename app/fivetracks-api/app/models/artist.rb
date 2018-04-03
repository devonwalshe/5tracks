class Artist < ApplicationRecord
  # Set Tablename
  self.table_name = "artist"
  
  # Scopes
  
  # Aliases
  alias_attribute :aliases, :artist_aliases
  alias_attribute :urls, :artist_urls
  alias_attribute :name_variations, :artist_name_variations
  alias_attribute :tracks, :release_tracks
  
  # relationships
  has_many :artist_aliases
  has_many :artist_urls
  has_many :artist_name_variations
  has_and_belongs_to_many :members, class_name: "Artist", join_table: :group_member, foreign_key: :group_artist_id, association_foreign_key: :member_artist_id
  has_and_belongs_to_many :groups, class_name: "Artist", join_table: :group_member, foreign_key: :member_artist_id, association_foreign_key: :group_artist_id
  has_many :release_artists
  has_many :releases, -> { distinct }, through: :release_artists
  has_many :release_labels, through: :releases
  has_many :labels, -> { distinct }, through: :release_labels
  has_many :release_track_artists
  has_many :release_tracks, -> {distinct}, through: :release_track_artists
  
  
  ###
  def self.label_id(label_id)
    return Label.find(label_id)
    
  end
  
  ### Class methods
  def main_tracks
    ReleaseTrack.joins(:release => {:release_artists => {:artist => :release_track_artists}}).where('artist.id': self.id, 'release_artist.extra':0, 'release_track_artist.extra': 'f').uniq
  end
  
  def supporting_tracks
    ReleaseTrack.joins(:release => {:release_artists => {:artist => :release_track_artists}}).where('artist.id': self.id, 'release_artist.extra':1, 'release_track_artist.extra': 't').uniq
  end

  def release_count
    self.releases.count
  end
  
  def stats
    years = []
    dates = []
    Artist.first.releases.map(&:released).each do |date|
      years << /\d{4}/.match(date)[0]
      matches = date.scan(/\d+/)
      if matches.length > 1
        dates << DateTime.strptime(date, "%Y-%m")
      end
    end
    release_counts = years.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    last_active = dates.max
    return {'releases': release_counts}
  end
end
