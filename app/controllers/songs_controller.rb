class SongsController < ApplicationController
  def new
    @song = Song.new
  end

  def create
    @song = Song.create(song_params)
    DownloadJob.perform_later(@song)
    redirect_to song_path(@song)
  end

  def show
    @song = Song.find(params[:id])
    redirect_to song_listen_path(@song) if @song.audio.present?
  end

  def listen
    @song = Song.find(params[:song_id])
    send_data @song.audio, type: 'audio/mpeg', disposition: 'inline'
  end

  private

  def song_params
    params.require(:song).permit(:source_url)
  end
end
