class Genre
  include Mongoid::Document

  field :title, type: String

  has_many :videos
end
