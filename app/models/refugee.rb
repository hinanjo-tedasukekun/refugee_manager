class Refugee < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :family

  has_many :refugee_vulnerabilities
  has_many :vulnerabilities, through: :refugee_vulnerabilities

  has_many :refugee_supplies
  has_many :supplies, through: :refugee_supplies

  has_many :refugee_allergens
  has_many :allergens, through: :refugee_allergens

  has_many :refugee_skills
  has_many :skills, through: :refugee_skills

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

  # 在宅避難者
  scope(:at_home,
        -> { joins(:family).merge(Family.at_home) })
  # 非在宅避難者
  scope(:not_at_home,
        -> { joins(:family).merge(Family.not_at_home) })
  # 世帯順
  scope(:family_order, -> { order(:family_id, :id) })

  # 対応するバーコードを返す
  def barcode
    @shelter ||= this_shelter
    @barcode ||= Barcode.from_id(@shelter.num, id)
  end

  # 世帯が存在していることのバリデーション
  def family_must_be_present
    errors.add(:family, :not_registered) unless family
  end

  # 世帯代表者であるかどうかを返す
  def leader?
    self == family.leader
  end

  # 基本情報が設定されているかどうかを返す
  def set_basic_info?
    !(name.blank? &&
      furigana.blank? &&
      gender == 'unspecified' &&
      age.blank?)
  end

  # アレルギーがあるかどうかを返す
  def have_allergies?
    (!other_allergens.blank?) || (!allergens.blank?)
  end
end
