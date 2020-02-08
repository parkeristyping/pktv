# frozen_string_literal: true

class CleanupJob < ApplicationJob
  def perform(_song)
    # Find songs more than 5 minutes old
    Song.where("created_at < now() - interval '5 minutes'").destroy_all

    # Find tmp files more than 5 minutes old
    `find /home/ubuntu/pktv/tmp -mmin +5 -type f -exec rm -fv {} \;`
  end
end
