class Supply < ActiveRecord::Base
  has_many :refugee_supplies
  has_many :refugees, through: :refugee_supplies

  validates :name,
    presence: true,
    length: { maximum: 32 }
end
