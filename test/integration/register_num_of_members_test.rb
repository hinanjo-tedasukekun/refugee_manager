require 'test_helper'

class RegisterNumOfMembersTest < ActionDispatch::IntegrationTest
  REFUGEE_ID = 101
  NUM_OF_MEMBERS = 3

  def register_num_of_members
    family = Family.create(num_of_members: NUM_OF_MEMBERS)
    refugee = Refugee.create(id: REFUGEE_ID, family: family)
    Leader.create(family: family, refugee: refugee)
  end

  test '家族の人数を登録できる' do
    register_num_of_members
    assert_equal(
      3, Leader.find_by(refugee_id: REFUGEE_ID).family.num_of_members
    )
  end

  test '家族の人数を更新できる' do
    register_num_of_members

    leader = Leader.find_by(refugee_id: REFUGEE_ID)
    assert leader

    family = leader.family
    assert family

    family.num_of_members = 5
    family.save

    assert_equal(
      5, Leader.find_by(refugee_id: REFUGEE_ID).family.num_of_members
    )
  end
end
