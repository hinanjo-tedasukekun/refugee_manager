class Family < ActiveRecord::Base
  has_many :refugees
  has_one :family_leader
  has_one :leader, through: :family_leader, source: 'refugee'

  enum at_home: {
    unspecified: 0, # 未指定
    at_home: 1,     # 在宅避難
    in_shelter: 2   # 避難所で避難する
  }

  validates :num_of_members,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than: 0
    }
  validates :at_home,
    presence: true
  validates :postal_code,
    format: { with: /\A(\d{7})?\Z/ }
end
