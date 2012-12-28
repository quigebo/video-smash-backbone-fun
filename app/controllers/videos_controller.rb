class VideosController < ApplicationController
  after_filter :cookie_last_genre_viewed

  respond_to :json

  def index
    genre = Genre.find params[:genre]

    respond_with current_user.fetch_unviewed_videos(genre, params[:offset])

    # respond_with videos: current_user.fetch_unviewed_videos(genre, params[:offset]),
    #              viewings: current_user.viewings.where(genre_id: genre.id)
    # also need to respond with previously viewed videos for genre
  end

private

  def cookie_last_genre_viewed
    cookies[:last_genre_viewed] = params[:genre]
  end
end
