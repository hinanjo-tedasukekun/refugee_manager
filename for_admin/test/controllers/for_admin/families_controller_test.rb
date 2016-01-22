require 'test_helper'

module ForAdmin
  class FamiliesControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
    end

    test "should get show" do
      get :show
      assert_response :success
    end

    test "should get edit" do
      get :edit
      assert_response :success
    end

    test "should get update" do
      get :update
      assert_response :success
    end

  end
end
