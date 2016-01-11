require 'test_helper'

class Profile::VulnerabilitiesControllerTest < ActionController::TestCase
  include ApplicationHelper
  include RefugeeSessionsHelper

  def setup
    @leader = create(:leader)
    @refugee = create(:refugee2)

    @vulnerability = create(:vulnerability)
    @vulnerability2 = create(:vulnerability2)

    @refugee.vulnerabilities = [@vulnerability]
    @refugee.save
  end

  test 'ログインしていない場合ログインページにリダイレクトされる' do
    assert_not refugee_logged_in?
    get :edit
    assert_redirected_to login_path
  end

  test 'タイトルに "要配慮事項" が含まれる' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'
    assert_select 'title', /要配慮事項/
  end

  test '選択されている項目が正しい' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'

    assert_select "#refugee_vulnerability_ids_#{@vulnerability.id}[checked]"
    assert_select "#refugee_vulnerability_ids_#{@vulnerability2.id}"
    assert_select "#refugee_vulnerability_ids_#{@vulnerability2.id}[checked]", count: 0
  end

  test '要配慮事項を更新できる' do
    refugee_log_in @refugee
    assert refugee_logged_in?

    patch :update, refugee: { vulnerability_ids: [@vulnerability2.id, ''] }

    @refugee.reload
    assert_equal [@vulnerability2], @refugee.vulnerabilities.to_a

    assert_redirected_to profile_path
    assert_not flash[:success].empty?
  end
end
