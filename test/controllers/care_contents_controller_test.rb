require "test_helper"

class CareContentsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get care_contents_edit_url
    assert_response :success
  end

  test "should get update" do
    get care_contents_update_url
    assert_response :success
  end
end
