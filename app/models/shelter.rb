class Shelter < ActiveRecord::Base
  validates :num,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 999
    }
  validates :name,
    presence: true
  validates :postal_code,
    format: { with: /\A(\d{7})?\Z/ }

  # 整形された郵便番号を返す
  def formatted_postal_code
    "#{postal_code[0, 3]}-#{postal_code[3, 4]}"
  end
end
