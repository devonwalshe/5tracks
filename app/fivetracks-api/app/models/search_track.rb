class SearchTrack
  include ActiveModel::Model
  attr_accessor :track_id, :score, :release_id, :artist_ids, :title, :release_title, :artist_names

  def track
    ReleaseTrack.find(self.track_id)
  end
  
  def artists
    Artist.where(id: self.artist_ids)
  end
  
  def release
    Release.find(self.release_id)
  end
  
  # # Relationships
  # has_one :track

  def to_jsonapi
    d = {id: self.track_id,
      type: "search-track",
      links: {self: "#{ROOT_URL}/release-tracks/#{self.track_id}"},
      attributes: {
        title: self.title,
        score: self.score,
        'artist-names': self.artist_names,
        'release-title': self.release_title
        },
      relationships: {
        artists: {
          links: {
            self: "#{ROOT_URL}/release-tracks/#{self.track_id}/relationships/artists",
            related: "#{ROOT_URL}/release-tracks/#{self.track_id}/artists"
            }
        },
        'main-release-artists':{
          links: {
            self: "#{ROOT_URL}/release-tracks/#{self.track_id}/relationships/main-release-artists",
            related: "#{ROOT_URL}/release-tracks/#{self.track_id}/main-release-artists"
          }
        },
        release: {
          links: {
            self: "#{ROOT_URL}/release-tracks/#{self.track_id}/relationships/release",
            related: "#{ROOT_URL}/release-tracks/#{self.track_id}/release"
            }
        }
      }
    }
    return d
  end

end
