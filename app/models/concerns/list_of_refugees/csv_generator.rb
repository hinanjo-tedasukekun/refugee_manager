require 'csv'

module ListOfRefugees
  # CSV 生成器
  class CsvGenerator
    # 名簿のタイトル
    # @return [String]
    attr_accessor :title
    # 出力対象の避難者の集合
    attr_accessor :refugees

    # コンストラクタ
    def initialize(refugees, title = '避難者名簿')
      @title = title
      @refugees = refugees.
        includes(:family,
                 :vulnerabilities,
                 :supplies,
                 :skills).
        family_order
    end

    # CSV を生成する
    # @return [String]
    def generate(title: true, shelter_info: true)
      current_locale = I18n.locale

      output = CSV.generate do |csv|
        export_title(csv) if title
        export_shelter_info(csv) if shelter_info
        export_refugees(csv)
      end

      I18n.locale = current_locale

      output
    end

    private

    # タイトルを出力する
    def export_title(csv)
      csv << [@title]
      csv << []
    end

    # 避難所情報を出力する
    def export_shelter_info(csv)
      app = Object.new.extend(ApplicationHelper)
      shelter = app.this_shelter

      csv << ['避難所番号', shelter.num]
      csv << ['避難所名',   shelter.name]
      csv << ['避難所住所', shelter.address]
      csv << []
    end

    # 複数の項目を連結する
    # @param [Enumerable] items 項目の集合
    # @return [String]
    def join_items(items)
      items.map(&:name).join('・')
    end

    # 避難者情報を出力する
    def export_refugees(csv)
      csv << %w(世帯番号 在宅避難 避難者番号 氏名 住所 性別 年齢 要配慮項目 必需品 得意な分野)
      @refugees.each do |r|
        f = r.family
        csv << [
          r.family_id,
          f.at_home_i18n,
          r.barcode.code,
          r.name,
          f.address,
          r.gender_i18n,
          r.age,
          join_items(r.vulnerabilities),
          join_items(r.supplies),
          join_items(r.skills)
        ]
      end
    end
  end
end
