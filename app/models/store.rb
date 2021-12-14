class Store < ApplicationRecord
  mount_uploader :avatar, PictureUploader

  #validates :name, :address, :city, :state, :postal_code, :longitude, :latitude, presence: true
  has_many :products
  belongs_to :state
  belongs_to :city

  before_commit :update_latitude_and_longitude

  def full_address
    [self.address, self.city.name, self.state.name].join(', ')
  end
  
  def full_address_v2
    "#{self.address} #{self.city.name} #{self.state.abbreviation}".gsub(" ", "+")
  end

  def update_latitude_and_longitude
    return if self.latitude.present?
    resp =  HTTParty.get "https://maps.googleapis.com/maps/api/geocode/json?address=#{full_address_v2}&key=AIzaSyAvwMrjYJ-pgIW-gEaxSQFkIqEPvwnNyQI"
    return if resp["status"] != "OK"
    location =  resp["results"].first["geometry"]["location"]
    _address = resp["results"].first["formatted_address"].split(",")
    self.address = _address[0].strip
    _state = State.find_by(abbreviation: _address[2].strip[0..1])
    return if _state.blank?
    _city = City.find_or_create_by(state_id: _state.id, name: _address[1].strip)
    self.city_id = _city.id
    self.latitude = location["lat"]
    self.longitude = location["lng"]
  end
end
