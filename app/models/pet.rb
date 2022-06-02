class Pet < ApplicationRecord
  belongs_to :user
  has_many :vet_registrations, dependent: :destroy
  has_many :appointments, dependent: :destroy
end
