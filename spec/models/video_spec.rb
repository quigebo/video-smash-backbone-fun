require 'spec_helper'

describe Video, '#generate_color' do
  it 'ensures a video gets a unique color' do
    video = Video.create color: 'FFF'
    other_video = Video.new color: 'FFF'

    expect {
      other_video.generate_color
    }.to change(other_video, :color)
  end

  it 'ensures a 6 character hex code' do
    video = Video.new
    video.stub generate_hex: 1_000.to_s(16)
    video.generate_color

    video.color.should == '0003e8'
  end
end
