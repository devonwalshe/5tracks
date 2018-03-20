class ReleaseTrackResource < JSONAPI::Resource
  attributes :title, :duration, :sequence, :artist_count, :queued, :release_id, :on_queue, :position
  
  ## Relationships
  has_many :artists
  has_one :release
  has_one :label
  has_many :release_track_artists
  has_many :main_release_artists
  # has_many :main_artists, class_name: "Artist", relation_name: :main_artists
  # has_many :extra_artists, class_name: "Artist", relation_name: :main_artists
  
  def artist_count
    @model.artists.count
  end
end
