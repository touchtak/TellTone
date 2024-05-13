require "test_helper"

class CreatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get creators_new_url
    assert_response :success
  end

  test "should get create" do
    get creators_create_url
    assert_response :success
  end

  test "should get show" do
    get creators_show_url
    assert_response :success
  end

  test "should get edit" do
    get creators_edit_url
    assert_response :success
  end

  test "should get update" do
    get creators_update_url
    assert_response :success
  end

  test "should get index" do
    get creators_index_url
    assert_response :success
  end
end
