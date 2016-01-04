# バーコードのチェックディジットが正しいか判定するバリデータ
class CheckDigitValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless /\A\d{8}\z/ === value

    expected_check_digit = Barcode.check_digit(value[0, 7])
    unless value[-1].to_i == expected_check_digit
      record.errors.add(attribute,
                        (options[:message] || :contains_bad_check_digit))
    end
  end
end
