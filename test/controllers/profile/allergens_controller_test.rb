require 'test_helper'

class Profile::AllergensControllerTest < ActionController::TestCase
  include ApplicationHelper
  include RefugeeSessionsHelper

  def setup
    @leader = create(:leader)
    @refugee = create(:refugee2)

    @allergen = create(:allergen)
    @allergen2 = create(:allergen2)

    @refugee.allergens = [@allergen]
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

  test 'アレルギーを更新できる' do
    refugee_log_in @refugee
    assert refugee_logged_in?

    patch :update, refugee: { allergen_ids: [@allergen2.id, ''] }

    @refugee.reload
    assert_equal [@allergen2], @refugee.allergens.to_a

    assert_redirected_to profile_path
    assert_not flash[:success].empty?
  end
end
