Constants.genre_list.each do |title|
  genre = Genre.create title: title

  10_000.times do
    video = Video.build_unique
    video.genre = genre
    video.save
  end
end
