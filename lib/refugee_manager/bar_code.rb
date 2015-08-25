module RefugeeManager
  # 避難者に配られるバーコードを表すクラス
  class BarCode
    # @return [String] バーコードに含まれているコード
    attr_reader :code
    # @return [Fixnum] 避難所番号
    attr_reader :refuge_id
    # @return [Fixnum] 避難者番号
    attr_reader :refugee_id

    def initialize(code)
      @code = code
      @valid = correct_format?(@code) && is_check_digit_correct?(@code)

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

    private

    # コードの形式が正しいかどうかを返す
    def correct_format?(code)
      /\A\d{8}\z/ === code
    end

    # チェックディジットを求める
    def calc_check_digit(code)
      # コードを逆順にし、各文字を数値に変換する
      reversed_code = code.
        chars.
        reverse.
        map { |c| c.to_i }

      # 残りの数字
      digits = reversed_code.drop(1)

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
    def is_check_digit_correct?(code)
      check_digit = code.last.to_i

      check_digit == calc_check_digit(code)
    end
  end
end
