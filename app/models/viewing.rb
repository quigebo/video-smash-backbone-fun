class Viewing
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user

  belongs_to :video

  def formatted_created_at
    self.created_at.strftime "%-m/%-d/%Y %l:%M:%S%P"
  end
end
