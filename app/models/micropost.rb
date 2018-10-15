class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length:
    {maximum: Settings.maximum.content_length}
  validate  :picture_size
  private

  def picture_size
    errors.add(:picture, t("size_picture")) if picture.size > 5.megabytes
  end
end
