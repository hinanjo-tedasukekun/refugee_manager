class Leader < ActiveRecord::Base
  belongs_to :family
  belongs_to :refugee

  validates :family,
    presence: true,
    uniqueness: true
  validates :refugee,
    presence: true,
    uniqueness: true
end
