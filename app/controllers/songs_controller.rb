# frozen_string_literal: true

class SongsController < ApplicationController
  def create
    @song = Song.create(song_params)
    @song.update(event_log: [{ event: 'enqueued', time: Time.now }])
    ProcessJob.perform_later(@song)
    CleanupJob.perform_later
    redirect_to song_path(@song)
  end

  def show
    @song = Song.find(params[:id])
  end

  def listen
    @song = Song.find(params[:song_id])
    send_data @song.audio, type: 'audio/mpeg', disposition: 'inline'
  end

  private

  def song_params
    params.require(:song).permit(
      :source_url,
      :title
    )
  end
end
