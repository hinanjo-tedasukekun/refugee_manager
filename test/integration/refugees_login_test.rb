require 'test_helper'

class RefugeesLoginTest < ActionDispatch::IntegrationTest
  setup do
    @shelter = create(:shelter)
  end

  test '無効な番号でログインする' do
    host! NORMAL_HOST
    get login_path
    assert_template 'refugee_sessions/new'
    post login_path, session: { refugee_num: '0' }
    assert_template 'refugee_sessions/new'
    assert_not flash[:alert].empty?
    get root_path
    assert flash.empty?
  end

  test '登録されている番号でログインし、ログアウトする' do
    leader = FactoryGirl.create(:family_leader)
    refugee = leader.refugee
    refugee_num = Barcode.from_id(19, refugee.id).code

    host! NORMAL_HOST

    # ログイン
    get login_path
    assert_template 'refugee_sessions/new'
    post login_path, session: { refugee_num: refugee_num }
    assert refugee_logged_in?, 'ログインされている'
    assert_redirected_to profile_path
    follow_redirect!
    assert_select 'nav a[href=?]', login_path, count: 0
    assert_select 'nav a[href=?]', logout_path

    # ログアウト
    delete logout_path
    assert_nil assigns('current_refugee'), 'ログアウトされている'
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'nav a[href=?]', login_path
    assert_select 'nav a[href=?]', logout_path, count: 0
  end

  test '未登録の番号でログインする' do
    host! NORMAL_HOST
    get login_path
    assert_template 'refugee_sessions/new'

    num = Barcode.from_id(@shelter.num, 9999).code
    post login_path, session: { refugee_num: num }
    assert_redirected_to controller: 'profile', action: 'new', num: num
    follow_redirect!
    assert_select '#refugee_num', num
  end
end
