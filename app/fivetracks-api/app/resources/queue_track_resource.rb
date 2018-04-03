class QueueTrackResource < JSONAPI::Resource
  # Attrs
  attributes :in_library, :queue, :popularity_rating, :underground_rating, :similarity_rating, :total_rating, :release_track_id, :release_id, :user_id, :track_title, :release_title, :created_at, :updated_at
  
  # Relationships
  has_one :release
  has_one :release_track
  
  ## Filters
  filters :release_track_id, :release_id, :user_id, :queue, :created_at, :updated_at
  
  ## Custom attrs
  def track_title
    @model.release_track.title
  end
  
  def release_title
    @model.release.title
  end
  
end
