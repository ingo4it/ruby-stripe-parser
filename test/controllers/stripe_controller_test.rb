require "test_helper"

class StripeControllerTest < ActionDispatch::IntegrationTest
  test "should get webhook" do
    get stripe_webhook_url
    assert_response :success
  end
end
