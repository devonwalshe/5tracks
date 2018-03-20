class QueueTrack < ApplicationRecord
  # Callbacks
  after_save :get_ratings
  
  # Validations
  
  # Relationships
  belongs_to :release_track
  belongs_to :release
  
  private
  
  def get_ratings()
    # Do some crazy async shit with active job to pull ratings for queue tracks
  end
end
