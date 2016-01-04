module RefugeeSessionsHelper
  # 渡された避難者でログインする
  def refugee_log_in(refugee)
    session[:refugee_id] = refugee.id
  end

  # 現在ログインしている避難者を返す（ログイン中のみ）
  def current_refugee
    @current_refugee ||= Refugee.find_by(id: session[:refugee_id])
  end

  # 避難者がログインしているかどうかを返す
  def refugee_logged_in?
    !current_refugee.nil?
  end

  # ログイン済み避難者かどうか確認する
  # ログインしていなければログイン画面へリダイレクトする
  def logged_in_refugee
    redirect_to login_url unless refugee_logged_in?
  end
end
