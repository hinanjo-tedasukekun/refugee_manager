module ApplicationHelper
  # 避難所番号
  REFUGE_ID = 19

  # ページごとに完全なタイトルを返す
  def full_title(page_title = '')
    base_title =
      Subdomain::Admin.match?(request) ? '避難所管理システム' : '避難所'
    if page_title.empty?
      base_title
    else
      page_title + ' - ' + base_title
    end
  end

  # ナビゲーションバーのタイトルを返す
  def navbar_title
    Subdomain::Admin.match?(request) ? '避難所管理システム' : '避難所'
  end
end
