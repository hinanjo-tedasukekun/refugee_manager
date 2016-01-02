require 'test_helper'

class Profile::BasicInfoControllerTest < ActionController::TestCase
  include ApplicationHelper
  include RefugeeSessionsHelper

  def setup
    @leader = create(:leader)
    @refugee = create(:refugee2)
  end

  test 'ログインしていない場合ログインページにリダイレクトされる' do
    assert_not refugee_logged_in?
    get :edit
    assert_redirected_to login_path
  end

  test 'タイトルに "基本情報" が含まれる' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'
    assert_select 'title', /基本情報/
  end

  test 'リンクが正しい' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'
    assert_select 'a[href=?]', root_path
    assert_select 'form a[href=?]', profile_path
  end

  test '初期値が正しい' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'
    assert_select '#refugee_name[value=?]', @refugee.name
    assert_select '#refugee_furigana[value=?]', @refugee.furigana
    assert_select '#refugee_gender option[selected][value=?]',
      @refugee[:gender].to_s
    assert_select '#refugee_age[value=?]', @refugee.age.to_s
  end

  test '基本情報が正しく更新される' do
    refugee_log_in @refugee
    assert refugee_logged_in?

    new_name = 'アイウエオ'
    new_furigana = 'あいうえお'
    new_gender = Refugee.genders[:unspecified]
    new_age = 12

    params = {
      refugee: {
        name: new_name,
        furigana: new_furigana,
        gender: new_gender,
        age: new_age
      }
    }

    patch :update, params

    @refugee.reload
    assert_equal new_name, @refugee.name
    assert_equal new_furigana, @refugee.furigana
    assert_equal new_gender, @refugee[:gender]
    assert_equal new_age, @refugee.age

    assert_redirected_to profile_path
    assert_not flash[:success].empty?
  end

  test 'エラーがあった場合、更新されない' do
    refugee_log_in @refugee
    assert refugee_logged_in?

    old_name = @refugee.name
    old_furigana = @refugee.furigana
    old_gender = @refugee[:gender]
    old_age = @refugee.age

    new_name = 'アイウエオ'
    new_furigana = 'あいうえお'
    new_gender = Refugee.genders[:unspecified]
    new_age = -1

    params = {
      refugee: {
        name: new_name,
        furigana: new_furigana,
        gender: new_gender,
        age: new_age
      }
    }

    patch :update, params

    @refugee.reload
    assert_equal old_name, @refugee.name
    assert_equal old_furigana, @refugee.furigana
    assert_equal old_gender, @refugee[:gender]
    assert_equal old_age, @refugee.age

    assert_template 'edit'
    assert_select '#error-explanation'
  end
end
