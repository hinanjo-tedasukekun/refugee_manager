require 'csv'

# 避難者名簿生成モジュール
module ListOfRefugees
  # CSV 形式の避難者名簿を返す
  # @return [String]
  def to_csv
    app = Object.new.extend(ApplicationHelper)
    shelter = app.this_shelter
    refugees = Refugee.
      includes(:family,
               :vulnerabilities,
               :supplies,
               :skills).
      order(:family_id, :id)

    CSV.generate do |csv|
      # ロケールを日本語に固定する
      I18n.locale = :ja

      # 避難所情報を出力する
      csv << ['避難所番号', shelter.num]
      csv << ['避難所名',   shelter.name]
      csv << ['避難所住所', shelter.address]
      csv << []

      # 複数の項目の名前を連結する手続き
      join_names = ->items { items.map(&:name).join('・') }

      # 避難者情報を出力する
      csv << %w(世帯番号 在宅避難 氏名 住所 性別 年齢 要配慮項目 必需品 得意な分野)
      refugees.each do |r|
        f = r.family
        csv << [
          r.family_id,
          f.at_home_i18n,
          r.name,
          f.address,
          r.gender_i18n,
          r.age,
          join_names[r.vulnerabilities],
          join_names[r.supplies],
          join_names[r.skills]
        ]
      end
    end
  end

  module_function :to_csv
end
