require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  include ApplicationHelper
  include RefugeeSessionsHelper

  def setup
    @leader = create(:leader)
    @leader_refugee = @leader.refugee
    @family = @leader.family

    @refugee = create(:refugee2)

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
    assert_select '#refugee_num', @refugee.barcode.code
  end

  test '代表者の名前が空の場合、代表者番号が表示される' do
    @leader_refugee.name = ''
    assert @leader_refugee.save

    refugee_log_in @refugee
    assert refugee_logged_in?

    get :show

    assert_template 'show'
    assert_select '#leader_num', @leader_refugee.barcode.code
  end

  test '代表者の名前が空でない場合、代表者名が表示される' do
    assert_not @leader_refugee.name.empty?

    refugee_log_in @refugee
    assert refugee_logged_in?

    get :show

    assert_template 'show'
    assert_select '#leader_name', @leader_refugee.name
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
