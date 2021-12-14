class State < ApplicationRecord
  has_many :stores
  has_many :cities
end
