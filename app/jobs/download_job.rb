class DownloadJob < ApplicationJob
  def perform(song)
    # Download the song from youtube
    # Process the song with Spleeter
    # Upload the song to AWS
    # Update the record
  end
end
