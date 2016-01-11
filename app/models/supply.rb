class Supply < ActiveRecord::Base
  validates :name,
    presence: true,
    length: { maximum: 32 }
end
