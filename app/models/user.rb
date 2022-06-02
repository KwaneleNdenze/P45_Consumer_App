class User < ApplicationRecord
  has_many :pets, dependent: :destroy
  has_many :appointments, dependent: :destroy
end
