class QueueTrackResource < JSONAPI::Resource
  # Attrs
  attributes :in_library, :queue, :popularity_rating, :underground_rating, :similarity_rating, :total_rating, :release_track_id, :release_id
  
  # Relationships
  has_one :release
  has_one :release_track
  
  ## Filters
  filters :release_track_id, :release_id
end
