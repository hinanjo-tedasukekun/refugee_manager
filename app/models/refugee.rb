class Refugee < ActiveRecord::Base
  belongs_to :family

  enum gender: {
    unspecified: 0, # 未指定
    male: 1,        # 男性
    female: 2       # 女性
  }

  validates :name, length: { maximum: 64 }
  validates :furigana, length: { maximum: 64 }
  validates :age,
    allow_blank: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }
end
