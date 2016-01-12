require 'test_helper'

class Profile::SkillsControllerTest < ActionController::TestCase
  include ApplicationHelper
  include RefugeeSessionsHelper

  def setup
    @leader = create(:leader)
    @refugee = create(:refugee2)

    @skill = create(:skill)
    @skill2 = create(:skill2)

    @refugee.skills = [@skill]
    @refugee.save
  end

  test 'ログインしていない場合ログインページにリダイレクトされる' do
    assert_not refugee_logged_in?
    get :edit
    assert_redirected_to login_path
  end

  test 'タイトルに "得意な分野" が含まれる' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'
    assert_select 'title', /得意な分野/
  end

  test '選択されている項目が正しい' do
    refugee_log_in @refugee
    assert refugee_logged_in?
    get :edit
    assert_template 'edit'

    assert_select "#refugee_skill_ids_#{@skill.id}[checked]"
    assert_select "#refugee_skill_ids_#{@skill2.id}"
    assert_select "#refugee_skill_ids_#{@skill2.id}[checked]", count: 0
  end

  test 'アレルギーを更新できる' do
    refugee_log_in @refugee
    assert refugee_logged_in?

    patch :update, refugee: { skill_ids: [@skill2.id, ''] }

    @refugee.reload
    assert_equal [@skill2], @refugee.skills.to_a

    assert_redirected_to profile_path
    assert_not flash[:success].empty?
  end
end
