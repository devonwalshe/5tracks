class ReleaseResource < JSONAPI::Resource
  attributes :title, :released, :country, :notes, :master_id, :artist_count
  has_many :release_videos
  has_many :release_tracks
  has_many :artists
  has_many :main_artists
  has_many :extra_artists
  has_one :label
  has_many :release_genres

  def artist_count
    @model.artists.count
  end
  
  
  
end
