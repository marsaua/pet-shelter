require "test_helper"

class AdoptsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get adopts_index_url
    assert_response :success
  end

  test "should get create" do
    get adopts_create_url
    assert_response :success
  end
end
