require 'spec_helper'

describe User, '#view_video' do
  let(:user) { User.create }
  let(:video) { Video.create color: 'fff' }
  
  it 'creates a new viewing with the video' do
    expect {
      user.view_video(video.id, 1)
    }.to change{user.viewings.count}.by(1)

    user.viewings.last.video_id.should == video.id
  end
end

describe User, '#fetch_unviewed_videos' do
  before do
    Video.delete_all
  end

  let(:user) { User.create }

  it 'doesnt return any previously viewed videos' do
    genre = stub id: 1

    video_one = Video.create genre_id: 1, color: '001'
    video_two = Video.create genre_id: 1, color: '002'

    user.fetch_unviewed_videos(genre).count.should == 2

    user.view_video(video_one.id, genre.id)

    user.fetch_unviewed_videos(genre).count.should == 1
  end
end

describe User, '#fetch_viewings_with_video_data' do
  before do
    Video.delete_all
  end

  let(:genre) { stub id: 1, title: 'hilarious' }
  let(:user)  { User.create }
  let(:video) { Video.create! genre_id: '1', color: 'greenz', title: 'good video' }

  it 'returns all of the viewings with merged in video data based on the genre' do
    Video.create genre_id: 2

    user.view_video video.id, genre.id

    viewing = user.viewings.last

    user.fetch_viewings_with_video_data(genre).should == [
      {
        color: video.color,
        title: video.title,
        genre: genre.title,
        created_at: viewing.formatted_created_at
      }
    ]
  end
end
