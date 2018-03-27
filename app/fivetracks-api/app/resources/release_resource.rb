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
  
  filter :label_id, apply: ->(records, value, _options) {
    records.joins(:release_label).where('release_label.label_id = ?', value).distinct
  }
  
  filter :artist_id, apply: ->(records, value, _options) {
    records.joins(:artists).where('release_artist.artist_id = ? and release_artist.extra = ?', value, 0).distinct
  }
  
  
end
