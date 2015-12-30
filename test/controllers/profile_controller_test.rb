require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  include RefugeeSessionsHelper

  def setup
    @leader = create(:leader)
    @family = @leader.family
    @refugee = @leader.refugee
  end

  test 'ログインしていない場合ホームページにリダイレクトされる' do
    @request.host = NORMAL_HOST
    assert_not refugee_logged_in?
    get :show
    assert_redirected_to login_path
  end

  test 'タイトルに "個人情報" が含まれる' do
    @request.host = NORMAL_HOST
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :show
    assert_select 'title', /個人情報/
  end

  test '正しい避難者番号が表示される' do
    @request.host = NORMAL_HOST
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :show
    assert_select '.refugee-num td', @refugee.barcode.code
  end
end
