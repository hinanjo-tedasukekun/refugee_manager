module ApplicationHelper
  # 避難所番号
  SHELTER_ID = 19

  # ページごとに完全なタイトルを返す
  def full_title(page_title = '')
    base_title = '避難所'
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
