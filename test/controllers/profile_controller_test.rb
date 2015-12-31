require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  include ApplicationHelper
  include RefugeeSessionsHelper

  def setup
    @leader = create(:leader)
    @family = @leader.family
    @refugee = @leader.refugee

    @request.host = NORMAL_HOST
  end

  test 'ログインしていない場合ホームページにリダイレクトされる' do
    assert_not refugee_logged_in?
    get :show
    assert_redirected_to login_path
  end

  test 'タイトルに "個人情報" が含まれる' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :show
    assert_template 'show'
    assert_select 'title', /個人情報/
  end

  test '正しい避難者番号が表示される' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :show
    assert_template 'show'
    assert_select '.refugee-num td', @refugee.barcode.code
  end

  test '登録画面が表示される' do
    assert_not refugee_logged_in?

    num = RefugeeManager::BarCode.from_id(REFUGE_ID, 9999).code
    name = 'foo bar'
    furigana = 'ふー ばー'

    get :new, num: num, name: name, furigana: furigana

    assert_template 'new'
    assert_select '#refugee_num', num
    assert_select '#refugee_name[value=?]', name
    assert_select '#refugee_furigana[value=?]', furigana
  end

  test '避難者番号が指定されない場合、登録画面が表示されない' do
    assert_not refugee_logged_in?

    get :new

    assert_redirected_to login_path
    assert_not flash.empty?
  end

  test '無効な避難者番号が指定された場合、登録画面が表示されない' do
    assert_not refugee_logged_in?

    get :new, num: '012'

    assert_redirected_to login_path
    assert_not flash.empty?
  end
end
