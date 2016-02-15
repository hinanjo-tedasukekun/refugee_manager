module ForAdmin
  module ApplicationHelper
    # 現在の避難所を返す
    def this_shelter
      Shelter.find(1)
    end

    # ページごとに完全なタイトルを返す
    def full_title(page_title = '')
      base_title = '避難所管理システム'
      if page_title.empty?
        base_title
      else
        page_title + ' - ' + base_title
      end
    end

    # 日時を整形する
    def format_time(time)
      time.strftime('%F %T')
    end
  end
end
