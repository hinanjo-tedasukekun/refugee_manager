require 'csv'

# 避難者名簿生成モジュール
module ListOfRefugees
  # 避難者全員の名簿を返す
  def all
    generator = CsvGenerator.new(Refugee.all, '避難者名簿（全員）')
    generator.generate
  end

  # 非在宅避難者の名簿を返す
  def not_at_home
    generator = CsvGenerator.new(Refugee.not_at_home,
                                 '避難者名簿（非在宅避難）')
    generator.generate
  end

  # 在宅避難者の名簿を返す
  def at_home
    generator = CsvGenerator.new(Refugee.at_home,
                                 '在宅避難者名簿')
    generator.generate
  end

  module_function :all, :not_at_home, :at_home
end
