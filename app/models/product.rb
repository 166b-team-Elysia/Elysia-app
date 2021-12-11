class Product < ApplicationRecord
  mount_uploader :cover, PictureUploader

  belongs_to :store
  has_many :order_products
  has_many :reviews

  def stars
    return nil if self.reviews.blank?
    levels = self.reviews.pluck(:level)
    (levels.sum.to_f / levels.size).round
  end
end
