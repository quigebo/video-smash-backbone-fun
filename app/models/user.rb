class User
  include Mongoid::Document

  embeds_many :viewings
  accepts_nested_attributes_for :viewings

  def self.create_new
    create
  end

  def view_video(video_id, genre_id)
    new_viewing = viewings.build video_id: video_id, genre_id: genre_id

    new_viewing.save
  end

  def fetch_unviewed_videos(genre, offset=0, limit=10)
    offset ||= 0
    excluded_video_ids = viewings.map(&:video_id)

    Video.excluding(excluded_video_ids).
          offset(offset).
          where(genre_id: genre.id).
          limit(limit)
  end

  def fetch_viewings_with_video_data(genre)
    viewings      = self.viewings.select{|viewing| viewing.genre_id.to_s == genre.id.to_s }
    viewed_videos = Video.find viewings.map(&:video_id)

    viewings.map do |viewing|
      video = viewed_videos.find{|video| video.id == viewing.video_id }
      {
        color: video.color,
        title: video.title,
        genre: genre.title,
        created_at: viewing.formatted_created_at
      }
    end
  end
end
