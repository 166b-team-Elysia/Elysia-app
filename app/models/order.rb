class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products
  accepts_nested_attributes_for :order_products
  has_many :products, through: :order_products

  enum order_status: [:unpaid, :paid, :refund]
  before_create :generate_number

  def generate_number
    self.number = "EL#{Time.now.strftime("%Y%m%d%H")}#{rand(1000..9999)}"
  end
end
