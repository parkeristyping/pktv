# frozen_string_literal: true

require 'google/apis/youtube_v3'

class SearchesController < ApplicationController
  def new
    @search = params[:q]
    @results = []
    if @search.present?
      yt = Google::Apis::YoutubeV3::YouTubeService.new
      yt.key = ENV['GOOGLE_API_KEY']
      @results = yt.list_searches('snippet', q: @search).items
      @songs = @results.map do |result|
        Song.new(source_url: "https://youtube.com/watch?v=#{result.id.video_id}", title: result.snippet.title)
      end
    end
  end

  def create
    redirect_to new_search_path(q: params[:q])
  end
end
