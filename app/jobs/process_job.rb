# frozen_string_literal: true

class ProcessJob < ApplicationJob
  def perform(song)
    log(song, 'getting lyrics')
    genius_song = Genius::Song.search(
      song.title.downcase
        .gsub(/[\(\)\[\-\]]/, '')
        .gsub('lyrics', '')
        .gsub('official music video', '')
        .gsub('official video', '')
        .gsub('official', '')
        .gsub('hq video', '')
        .gsub('hq audio', '')
    ).first

    if genius_song.present?
      song.update(lyrics_url: genius_song.url)
      log(song, 'lyrics found - downloading lyrics')
      agent = Mechanize.new
      page = agent.get(genius_song.url)
      lyrics = page.search('.song_body-lyrics').presence&.text
      if lyrics.present?
        song.update(lyrics: lyrics)
        log(song, 'downloaded lyrics')
      else
        log(song, 'failed to download lyrics')
      end
    else
      log(song, 'no lyrics found')
    end

    log(song, 'starting song download')
    # Download the song from youtube
    id = SecureRandom.uuid
    `youtube-dl -x --audio-format mp3 -o '#{Rails.root}/tmp/#{id}.mp3' #{song.source_url}`
    log(song, 'song downloaded')
    log(song, 'removing vocals (hang on, this takes a minute)')

    # Process the song with Spleeter
    `spleeter separate -i #{Rails.root}/tmp/#{id}.mp3 -p spleeter:2stems -o #{Rails.root}/tmp`
    log(song, 'vocals removed')

    # Convert wav to mp3
    `ffmpeg -i #{Rails.root}/tmp/#{id}/accompaniment.wav -codec:a libmp3lame -qscale:a 2 #{Rails.root}/tmp/#{id}/accompaniment.mp3`
    log(song, 'audio format converted')

    # Save it!
    song.update(audio: File.read("#{Rails.root}/tmp/#{id}/accompaniment.mp3"))
  rescue StandardError => e
    song.update(event_log: song.event_log << { event: 'error', time: Time.now }, error: e)
  end

  private

  def log(song, event)
    song.update(event_log: song.event_log << { event: event, time: Time.now })
  end
end
