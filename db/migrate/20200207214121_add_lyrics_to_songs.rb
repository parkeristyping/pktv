# frozen_string_literal: true

class AddLyricsToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :lyrics_url, :text
    add_column :songs, :lyrics, :text
  end
end
