class ReleaseTrack < ApplicationRecord
  # Set Tablename
  self.table_name = "release_track"
  
  ## Relationships
  belongs_to :release
  has_many :release_track_artists, foreign_key: :release_track_id
  has_one :release_label, foreign_key: :release_id, primary_key: :release_id
  has_one :label, through: :release_label
  has_many :artists, through: :release_track_artists
  has_many :release_artists, -> {where('release_artist.extra': 0)}, foreign_key: :release_id, primary_key: :release_id
  has_many :main_release_artists, class_name: "Artist", through: :release_artists, source: :artist
  
  def main_artists
    Artist.joins(:release_track_artists).where('release_track_artist.release_track_id': self.id, 'release_track_artist.extra': 'f').uniq
  end
  
  def extra_artists
    Artist.joins(:release_track_artists).where('release_track_artist.release_track_id': self.id, 'release_track_artist.extra': 't').uniq
  end
  
  def queued
    if QueueTrack.exists?(release_track_id: self.id)
      return true
    else
      return false
    end
  end
  
  def on_queue
    if QueueTrack.exists?(release_track_id: self.id)
      qt = QueueTrack.where(release_track_id: self.id).first
      return qt.queue
    else
      return nil
    end
  end
  
  # def release_artists
  #   Artist.joins(:release_artists).where('release_artist.release_id': self.release_id, 'release_artist.extra': 0).uniq
  # end
end
