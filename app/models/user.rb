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
  belongs_to :state
  belongs_to :city, optional: true

  enum role: [:customer, :admin]

  before_commit :update_latitude_and_longitude, on: [ :create, :update ]

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

  def full_address_v2
    "#{self.address} #{self.city&.name} #{self.state.abbreviation}".gsub(" ", "+")
  end

  def update_latitude_and_longitude
    return if self.latitude.present? || self.address.blank?
    resp =  HTTParty.get "https://maps.googleapis.com/maps/api/geocode/json?address=#{full_address_v2}&key=AIzaSyAvwMrjYJ-pgIW-gEaxSQFkIqEPvwnNyQI"
    return if resp["status"] != "OK"
    location =  resp["results"].first["geometry"]["location"]
    _address = resp["results"].first["formatted_address"].split(",")
    self.address = _address[0].strip
    _state = State.find_by(abbreviation: _address[2].strip[0..1]) rescue self.state
    return if _state.blank?
    _city = City.find_or_create_by(state_id: _state.id, name: _address[1].strip)
    self.city_id = _city.id
    self.latitude = location["lat"]
    self.longitude = location["lng"]
  end
  
  def distance(store)
    return 0 if self.latitude.blank? || store.latitude.blank?
    route = Google::Maps.route([self.latitude, self.longitude].join(","), [store.latitude, store.longitude].join(","))
    route.distance.value
  end
end