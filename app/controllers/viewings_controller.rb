class ViewingsController < ApplicationController
  respond_to :json

  def index
    genre = Genre.find params[:genre_id]
    viewings = current_user.fetch_viewings_with_video_data genre

    respond_with viewings
  end

  def create
    viewing_saved = current_user.view_video params[:video_id], params[:genre_id]

    if viewing_saved
      render nothing: true,
             status:  201
    else
      render nothing: true,
             status:  400
    end
  end
end
