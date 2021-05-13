require "test_helper"

class TaskControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get task_new_url
    assert_response :success
  end
end
