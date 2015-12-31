require 'test_helper'

class LeaderTest < ActiveSupport::TestCase
  def setup
    @leader = create(:leader)
  end

  test '有効である' do
    assert @leader.valid?
  end

  test '世帯は必須である' do
    @leader.family = nil
    assert_not @leader.valid?
  end

  test '世帯はユニークである' do
    refugee2 = create(:refugee2)
    leader2 = Leader.new(family: @leader.family, refugee: refugee2)
    assert_not leader2.valid?
  end

  test '避難者は必須である' do
    @leader.refugee = nil
    assert_not @leader.valid?
  end

  test '避難者はユニークである' do
    other_family = create(:family)
    leader2 = Leader.new(family: other_family, refugee: @leader.refugee)
    assert_not leader2.valid?
  end
end
