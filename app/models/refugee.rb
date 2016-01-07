class Refugee < ActiveRecord::Base
  belongs_to :family
  has_many :vulnerabilities
  has_many :vulnerability_types, through: :vulnerabilities

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

  # パスワード変更時のみバリデーションを行う
  # @see http://qiita.com/kadoppe/items/061d137e6022fa099872
  with_options on: :change_password do
    validates :password,
      absence: true,
      unless: :password_protected?

    validates :password,
      presence: true,
      confirmation: true,
      length: { minimum: 4 },
      if: :password_protected?
    validates :password_confirmation,
      presence: true,
      if: :password_protected?
  end

  # 対応するバーコードを返す
  def barcode
    @barcode ||= Barcode.from_id(ApplicationHelper::SHELTER_ID, id)
  end

  # 世帯が存在していることのバリデーション
  def family_must_be_present
    if family.nil?
      errors.add(:family, :not_registered)
    end
  end

  # 基本情報が設定されているかどうかを返す
  def set_basic_info?
    !(name.blank? &&
      furigana.blank? &&
      gender == 'unspecified' &&
      age.blank?)
  end
end
