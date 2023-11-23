require "test_helper"

class PromptsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get prompts_index_url
    assert_response :success
  end

  test "should get search" do
    get prompts_search_url
    assert_response :success
  end
end
