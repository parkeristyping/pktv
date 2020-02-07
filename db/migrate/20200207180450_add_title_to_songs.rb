# frozen_string_literal: true

class AddTitleToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :title, :text
  end
end
