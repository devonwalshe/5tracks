class ReleaseTrackArtistResource < JSONAPI::Resource
  attributes :artist_id, :extra, :join_string, :role
  has_one :artist
end
