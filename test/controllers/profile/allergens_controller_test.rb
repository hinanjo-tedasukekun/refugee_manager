require 'test_helper'

class Profile::AllergensControllerTest < ActionController::TestCase
  include ApplicationHelper
  include RefugeeSessionsHelper

  def setup
    @leader = create(:family_leader)
    @refugee = create(:refugee2)

    @allergen = create(:allergen)
    @allergen2 = create(:allergen2)

    @refugee.allergens = [@allergen]
    @refugee.other_allergens = 'やまいも'

    @refugee.save
  end

  test 'ログインしていない場合ログインページにリダイレクトされる' do
    assert_not refugee_logged_in?
    get :edit
    assert_redirected_to login_path
  end

  test 'タイトルに "アレルギー" が含まれる' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'
    assert_select 'title', /アレルギー/
  end

  test '選択されている項目が正しい' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'

    assert_select "#refugee_allergen_ids_#{@allergen.id}[checked]"
    assert_select "#refugee_allergen_ids_#{@allergen2.id}"
    assert_select "#refugee_allergen_ids_#{@allergen2.id}[checked]", count: 0
  end

  test 'その他のアレルゲンが表示される' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'

    assert_select '#refugee_other_allergens[value=?]', 'やまいも'
  end

  test 'アレルギーを更新できる' do
    refugee_log_in @refugee
    assert refugee_logged_in?

    new_other_allergens = 'やまいも、バナナ'
    patch :update, refugee: {
      allergen_ids: [@allergen2.id, ''],
      other_allergens: new_other_allergens
    }

    @refugee.reload
    assert_equal [@allergen2], @refugee.allergens.to_a
    assert_equal new_other_allergens, @refugee.other_allergens

    assert_redirected_to profile_path
    assert_not flash[:success].empty?
  end
end
