# バーコードのモデル
class Barcode
  include ActiveModel::Model
  include ActiveModel::Dirty

  # バーコードの番号を返す
  # @return [String]
  attr_accessor :code

  validates :code,
    length: { is: 8 },
    format: /\A\d{8}\z/,
    check_digit: true

  # チェックディジットを返す
  # @param [String] s 7 桁の数字列
  # @return [Fixnum] チェックディジット
  # @return [nil] s の形式が正しくなかった場合
  def self.check_digit(s)
    return nil unless /\A\d{7}\z/ === s

    d = s.chars.map(&:to_i)
    sum_odd = d[6] + d[4] + d[2] + d[0]
    sum_even = d[5] + d[3] + d[1]
    sum_mod10 = (sum_even + 3 * sum_odd) % 10

    sum_mod10 == 0 ? 0 : (10 - sum_mod10)
  end

  # 避難所番号と避難者番号からバーコードを作る
  # @param [Fixnum] shelter_id 避難所番号
  # @param [Fixnum] refugee_id 避難者番号
  # @return [Barcode]
  def self.from_id(shelter_id, refugee_id)
    unless (0..999).include?(shelter_id)
      raise ArgumentError,
        "shelter_id must be between 0 and 999: #{shelter_id}"
    end

    unless (0..9999).include?(refugee_id)
      raise ArgumentError,
        "refugee_id must be between 0 and 9999: #{refugee_id}"
    end

    data = '%03d%04d' % [shelter_id, refugee_id]
    code = "#{data}#{check_digit(data)}"

    new(code: code)
  end

  # バーコードの番号で等しいかどうかの比較を行う
  def ==(other)
    other.code == code
  end

  # 避難所番号を返す
  # @return [Fixnum]
  def shelter_id
    valid? ? code[0, 3].to_i : nil
  end

  # 避難者を返す
  # @return [Fixnum]
  def refugee_id
    valid? ? code[3, 4].to_i : nil
  end
end
