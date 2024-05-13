class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> {order(created_at: :desc)}

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}

  validates(
    :image,
    content_type: {
      in: %w[image/jpeg image/gif image/png],
      message: "must be a valid image format"
    },
    size: {less_than: 5.megabytes, message: "must be less than 5MB"}
  )
end
