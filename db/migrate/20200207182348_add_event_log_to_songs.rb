# frozen_string_literal: true

class AddEventLogToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :event_log, :jsonb, default: []
  end
end
