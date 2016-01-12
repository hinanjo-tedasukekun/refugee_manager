class Skill < ActiveRecord::Base
  has_many :refugee_skills
  has_many :refugees, through: :refugee_skills

  validates :name,
    presence: true,
    length: { maximum: 32 }
end
