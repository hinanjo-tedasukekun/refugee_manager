require 'test_helper'

class RegisterProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  test '代表者番号を入力しないと登録できない' do
    host! NORMAL_HOST
    post profile_new_path, refugee: { id: 9999 }
    assert_template 'profile/new'
    assert_select '#error-explanation'
  end

  test '無効な代表者番号を入力すると登録できない' do
    host! NORMAL_HOST
    post profile_new_path, refugee: { id: 9999 }, leader_num: '012'
    assert_template 'profile/new'
    assert_select '#error-explanation'
  end

  test '存在しない代表者番号を入力すると登録できない' do
    LEADER_ID = 9998

    host! NORMAL_HOST
    assert Refugee.find_by(id: LEADER_ID).nil?
    leader_num = Barcode.from_id(SHELTER_ID, LEADER_ID).code
    post profile_new_path, refugee: { id: 9999 }, leader_num: leader_num
    assert_template 'profile/new'
    assert_select '#error-explanation'
  end
end
