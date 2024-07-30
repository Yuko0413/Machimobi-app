require "test_helper"

class QrCodesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get qr_codes_show_url
    assert_response :success
  end
end
