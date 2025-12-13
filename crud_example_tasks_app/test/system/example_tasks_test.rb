require "application_system_test_case"

class ExampleTasksTest < ApplicationSystemTestCase
  setup do
    @example_task = example_tasks(:one)
  end

  test "visiting the index" do
    visit example_tasks_url
    assert_selector "h1", text: "Example tasks"
  end

  test "should create example task" do
    visit example_tasks_url
    click_on "New example task"

    click_on "Create Example task"

    assert_text "Example task was successfully created"
    click_on "Back"
  end

  test "should update Example task" do
    visit example_task_url(@example_task)
    click_on "Edit this example task", match: :first

    click_on "Update Example task"

    assert_text "Example task was successfully updated"
    click_on "Back"
  end

  test "should destroy Example task" do
    visit example_task_url(@example_task)
    click_on "Destroy this example task", match: :first

    assert_text "Example task was successfully destroyed"
  end
end
