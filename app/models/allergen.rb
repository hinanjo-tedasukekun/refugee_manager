class Allergen < ActiveRecord::Base
  has_many :refugee_allergens
  has_many :refugees, through: :refugee_allergens

  validates :name,
    presence: true,
    length: { maximum: 32 }
end
