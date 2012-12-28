class Video
  include Mongoid::Document

  field :title, type: String
  field :color, type: String
  index({ color: 1 }, { unique: true })

  belongs_to :genre
  index({ genre_id: 1 })

  validates :color, presence: true,
                    uniqueness: true

  def self.build_unique
    video = new
    video.generate_color
    video.generate_title

    video
  end

  def self.excluding(excluded_ids)
    return scoped unless excluded_ids.present?

    scoped.where :id.nin => excluded_ids
  end

  def self.find_by_title(title)
    where title: title
  end

  def generate_title
    self.title = "Video #{rand(100_000_000)}#{color}"
  end

  def generate_color
    until valid?
      hex_code = generate_hex
      zero_pad = "0" * (6 - hex_code.length)

      self.color = "#{zero_pad}#{hex_code}"
    end
  end

  def generate_hex
    rand(16_777_216).to_s(16)
  end
end
