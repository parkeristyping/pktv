# frozen_string_literal: true

require 'google/apis/youtube_v3'

class SearchesController < ApplicationController
  def new
    @search = params[:q]
    yt = Google::Apis::YoutubeV3::YouTubeService.new
    yt.list_videos('Weezer')
  end

  def create
    redirect_to new_search_path(q: params[:q])
  end
end
