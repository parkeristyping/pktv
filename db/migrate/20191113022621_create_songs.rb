class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.text :source_url
      t.binary :audio

      t.timestamps
    end
  end
end
