class Api::V1::ActorsController < ApplicationController
  before_action :set_actor, only: [:show, :update, :destroy]

  # GET /api/v1/actors
  def index
    @actors = Actor.all
    render json: @actors
  end

  # GET /api/v1/actors/:id
  def show
    render json: @actor
  end

  # POST /api/v1/actors
  def create
    @actor = Actor.new(actor_params)
    if @actor.save
      render json: @actor, status: :created, location: api_v1_actor_url(@actor)
    else
      render json: @actor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/actors/:id
  def update
    if @actor.update(actor_params)
      render json: @actor
    else
      render json: @actor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/actors/:id
  def destroy
    @actor.destroy
    head :no_content
  end

  private

  def set_actor
    @actor = Actor.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Actor not found' }, status: :not_found
  end

  def actor_params
    params.require(:actor).permit(:name, :country)
  end
end