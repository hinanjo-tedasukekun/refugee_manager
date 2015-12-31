class Refugee < ActiveRecord::Base
  belongs_to :family
  has_many :vulnerabilities

  enum gender: {
    unspecified: 0, # 未指定
    male: 1,        # 男性
    female: 2       # 女性
  }

  has_secure_password validations: false

  validate :family_must_be_present
  validates :name, length: { maximum: 64 }
  validates :furigana, length: { maximum: 64 }
  validates :age,
    allow_blank: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }

  validates :password,
    presence: true,
    length: { minimum: 4, maximum: 72 },
    if: :use_password?

  # 対応するバーコードを返す
  def barcode
    @barcode ||= RefugeeManager::BarCode.from_id(ApplicationHelper::REFUGE_ID, id)
  end

  def family_must_be_present
    if family.nil?
      errors.add(:family, :not_registered)
    end
  end
end
