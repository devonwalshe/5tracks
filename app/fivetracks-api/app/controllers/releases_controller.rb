class ReleasesController < ApplicationController
  
  def tracks_to_queue()
    begin
      #Check if user is here
      id = params[:id].to_i
      tracks = ReleaseTrack.where(release_id: id)
      # remove tracks which are already in a queue
      tracks = tracks.where.not(id: QueueTrack.all.map{|qt| qt.release_track_id})
      tracks.each do |t|
        qt = QueueTrack.new(release_id: id, user_id: current_user.id, release_track_id: t.id, queue: "scrub")
        qt.save
      end
      render json: tracks.count
    rescue => e
      handle_exceptions(e)
    end
  end
end
