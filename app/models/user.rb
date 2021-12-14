class User < ApplicationRecord
  mount_uploader :avatar, PictureUploader
  has_secure_password
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  after_create :create_cart

  acts_as_messageable
  

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_one :cart
  has_many :cart_products, through: :cart
  has_many :orders

  enum role: [:customer, :admin]

  def mailboxer_email(object)
    nil
  end
  
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    $login_redis_client.set(self.id, self.remember_token)
  end

  def authenticated?(remember_token)
    remember_digest = $login_redis_client.get(self.id)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(self.remember_token) rescue false
  end

  def forget
    $login_redis_client.del(self.id)
  end
  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_token || remember
  end

  def create_cart
    return if self.cart
    Cart.create(user: self)
  end
end