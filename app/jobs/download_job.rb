# frozen_string_literal: true

class DownloadJob < ApplicationJob
  def perform(song)
    song.update(event_log: song.event_log << { event: 'starting download', time: Time.now })
    # Download the song from youtube
    id = SecureRandom.uuid
    `youtube-dl -x --audio-format mp3 -o '#{Rails.root}/tmp/#{id}.mp3' #{song.source_url}`
    song.update(event_log: song.event_log << { event: 'downloaded', time: Time.now })

    # Process the song with Spleeter
    `spleeter separate -i #{Rails.root}/tmp/#{id}.mp3 -p spleeter:2stems -o #{Rails.root}/tmp`
    song.update(event_log: song.event_log << { event: 'vocals removed', time: Time.now })

    # Convert wav to mp3
    `ffmpeg -i #{Rails.root}/tmp/#{id}/accompaniment.wav -codec:a libmp3lame -qscale:a 2 #{Rails.root}/tmp/#{id}/accompaniment.mp3`
    song.update(event_log: song.event_log << { event: 'format converted', time: Time.now })

    # Save it!
    song.update(audio: File.read("#{Rails.root}/tmp/#{id}/accompaniment.mp3"))
  rescue StandardError => e
    song.update(event_log: song.event_log << { event: 'error', time: Time.now }, error: e)
  end
end
