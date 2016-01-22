require 'test_helper'

class Profile::SuppliesControllerTest < ActionController::TestCase
  include ApplicationHelper
  include RefugeeSessionsHelper

  def setup
    @leader = create(:family_leader)
    @refugee = create(:refugee2)

    @supply = create(:supply)
    @supply2 = create(:supply2)

    @refugee.supplies = [@supply]
    @refugee.save
  end

  test 'ログインしていない場合ログインページにリダイレクトされる' do
    assert_not refugee_logged_in?
    get :edit
    assert_redirected_to login_path
  end

  test 'タイトルに "必需品" が含まれる' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'
    assert_select 'title', /必需品/
  end

  test '選択されている項目が正しい' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'

    assert_select "#refugee_supply_ids_#{@supply.id}[checked]"
    assert_select "#refugee_supply_ids_#{@supply2.id}"
    assert_select "#refugee_supply_ids_#{@supply2.id}[checked]", count: 0
  end

  test '必需品を更新できる' do
    refugee_log_in @refugee
    assert refugee_logged_in?

    patch :update, refugee: { supply_ids: [@supply2.id, ''] }

    @refugee.reload
    assert_equal [@supply2], @refugee.supplies.to_a

    assert_redirected_to profile_path
    assert_not flash[:success].empty?
  end
end
