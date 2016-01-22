require 'test_helper'

class Profile::PasswordControllerTest < ActionController::TestCase
  include ApplicationHelper
  include RefugeeSessionsHelper

  def setup
    @leader = create(:family_leader)
    @refugee = create(:refugee2)
    @protected_refugee = create(:protected_refugee)
  end

  test 'ログインしていない場合ログインページにリダイレクトされる' do
    assert_not refugee_logged_in?
    get :edit
    assert_redirected_to login_path
  end

  test 'タイトルに "パスワード" が含まれる' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'
    assert_select 'title', /パスワード/
  end

  test 'パスワードなしからパスワードを設定することができる' do
    assert_not @refugee.password_protected?

    refugee_log_in @refugee
    assert refugee_logged_in?

    new_password = '12345678'
    params = {
      refugee: {
        password_protected: true,
        password: new_password,
        password_confirmation: new_password
      }
    }

    patch :update, params

    @refugee.reload
    assert @refugee.password_protected?
    assert @refugee.authenticate(new_password)

    assert_redirected_to profile_path
    assert_not flash[:success].empty?
  end

  test 'パスワードありからパスワードなしに設定することができる' do
    assert @protected_refugee.password_protected?
    refugee_log_in @protected_refugee
    assert refugee_logged_in?

    password = '12345678'
    params = {
      refugee: {
        password_protected: false,
        password: password,
        password_confirmation: password
      }
    }

    patch :update, params

    @refugee.reload
    assert_not @refugee.password_protected?

    assert_redirected_to profile_path
    assert_not flash[:success].empty?
  end

  test 'エラーがあった場合、更新されない' do
    assert_not @refugee.password_protected?

    refugee_log_in @refugee
    assert refugee_logged_in?

    new_password = '12345678'
    params = {
      refugee: {
        password_protected: true,
        password: new_password,
        password_confirmation: "#{new_password}9"
      }
    }

    patch :update, params

    @refugee.reload
    assert_not @refugee.password_protected?

    assert_template :edit
    assert_select '#error-explanation'
  end
end
