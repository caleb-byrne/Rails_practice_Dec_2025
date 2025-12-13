class ExampleTasksController < ApplicationController
  before_action :set_example_task, only: %i[ show edit update destroy ]

  # GET /example_tasks or /example_tasks.json
  def index
    @example_tasks = ExampleTask.all
  end

  # GET /example_tasks/1 or /example_tasks/1.json
  def show
  end

  # GET /example_tasks/new
  def new
    @example_task = ExampleTask.new
  end

  # GET /example_tasks/1/edit
  def edit
  end

  # POST /example_tasks or /example_tasks.json
  def create
    @example_task = ExampleTask.new(example_task_params)

    respond_to do |format|
      if @example_task.save
        format.html { redirect_to @example_task, notice: "Example task was successfully created." }
        format.json { render :show, status: :created, location: @example_task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @example_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /example_tasks/1 or /example_tasks/1.json
  def update
    respond_to do |format|
      if @example_task.update(example_task_params)
        format.html { redirect_to @example_task, notice: "Example task was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @example_task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @example_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /example_tasks/1 or /example_tasks/1.json
  def destroy
    @example_task.destroy!

    respond_to do |format|
      format.html { redirect_to example_tasks_path, notice: "Example task was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_example_task
      @example_task = ExampleTask.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def example_task_params
      params.require(:example_task).permit(:title, :description)
    end
end
