require "test_helper"

class ExampleTasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @example_task = example_tasks(:one)
  end

  test "should get index" do
    get example_tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_example_task_url
    assert_response :success
  end

  test "should create example_task" do
    assert_difference("ExampleTask.count") do
      post example_tasks_url, params: { example_task: {  } }
    end

    assert_redirected_to example_task_url(ExampleTask.last)
  end

  test "should show example_task" do
    get example_task_url(@example_task)
    assert_response :success
  end

  test "should get edit" do
    get edit_example_task_url(@example_task)
    assert_response :success
  end

  test "should update example_task" do
    patch example_task_url(@example_task), params: { example_task: {  } }
    assert_redirected_to example_task_url(@example_task)
  end

  test "should destroy example_task" do
    assert_difference("ExampleTask.count", -1) do
      delete example_task_url(@example_task)
    end

    assert_redirected_to example_tasks_url
  end
end
