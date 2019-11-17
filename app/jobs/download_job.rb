class DownloadJob < ApplicationJob
  def perform(song)
    # Download the song from youtube
    id = SecureRandom.uuid
    `youtube-dl -x --audio-format mp3 -o '#{Rails.root}/tmp/#{id}.mp3' #{song.source_url}`

    # Process the song with Spleeter
    `spleeter separate -i #{Rails.root}/tmp/#{id}.mp3 -p spleeter:2stems -o #{Rails.root}/tmp`

    # Convert wav to mp3
    `ffmpeg -i #{Rails.root}/tmp/#{id}/accompaniment.wav -codec:a libmp3lame -qscale:a 2 #{Rails.root}/tmp/#{id}/accompaniment.mp3`

    # Save it!
    song.update(audio: File.read("#{Rails.root}/tmp/#{id}/accompaniment.mp3"))
  end
end
