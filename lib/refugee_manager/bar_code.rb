module RefugeeManager
  # 避難者に配られるバーコードを表すクラス
  class BarCode
    # @return [String] バーコードに含まれているコード
    attr_reader :code
    # @return [Fixnum] 避難所番号
    attr_reader :refuge_id
    # @return [Fixnum] 避難者番号
    attr_reader :refugee_id

    # コードの形式が正しいかどうかを返す
    # @param [String] code バーコードに含まれているコード
    # @return [Boolean]
    def self.correct_format?(code)
      /\A\d{8}\z/ === code
    end

    # チェックディジットを求める
    # @param [String] code バーコードに含まれているコード
    # @return [Fixnum]
    def self.check_digit(code)
      # コードを逆順にし、各文字を数値に変換する
      digits = code.
        chars.
        reverse.
        map(&:to_i)

      # 奇数番目と偶数番目に分ける
      digits_odd, digits_even = digits.
        # 各要素に番号を付けて [d, i] の形にする
        each_with_index.
        # [奇数番目の数の [d, i] 配列, 偶数番目の数の [d, i] 配列]
        partition { |d, i| i.even? }.
        # [d, i] から d だけ取り出す
        map { |ds|
          ds.map { |d, i| d }
        }

      # 和を求める
      sum_odd = digits_odd.reduce(0, :+)
      sum_even = digits_even.reduce(0, :+)

      # 和を 10 で割った余り
      sum_mod_10 = (3 * sum_odd + sum_even) % 10

      # チェックディジット
      (sum_mod_10 == 0) ? 0 : (10 - sum_mod_10)
    end

    # チェックディジットが正しいかどうかを返す
    # @param [String] code バーコードに含まれているコード
    # @return [Boolean]
    def self.is_check_digit_correct?(code)
      code.last.to_i == check_digit(code[0...-1])
    end

    # 避難所番号、避難者番号からバーコード情報を生成する
    # @param [Fixnum] refuge_id 避難所番号
    # @param [Fixnum] refugee_id 避難者番号
    # @return [BarCode]
    def self.from_id(refuge_id, refugee_id)
      unless (0..999).include?(refuge_id)
        raise RangeError, "invalid refuge id: #{refuge_id}"
      end

      unless (0..9999).include?(refugee_id)
        raise RangeError, "invalid refugee id: #{refugee_id}"
      end

      data = '%03d%04d' % [refuge_id, refugee_id]
      new("#{data}#{check_digit(data)}")
    end

    def initialize(code)
      @code = code
      @valid = self.class.correct_format?(@code) &&
        self.class.is_check_digit_correct?(@code)

      if @valid
        @refuge_id = @code[0..2].to_i
        @refugee_id = @code[3..6].to_i
      else
        @refuge_id = nil
        @refugee_id = nil
      end
    end

    # バーコードが有効かどうかを返す
    def valid?
      @valid
    end
  end
end
