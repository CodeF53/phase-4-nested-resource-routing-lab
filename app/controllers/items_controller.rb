class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def create
    user = User.find(params[:user_id])
    item = Item.create(item_params)
    render json: item, status: :created
  end

  def show
    user = User.find(params[:user_id])
    item = Item.find(params[:id])
    render json: item
  end

  private

  def find_item
    Item.find(params[:id])
  end

  def item_params
    params.permit(:user_id, :name, :description, :price)
  end

  def render_not_found_response
    render json: { error: 'item not found' }, status: :not_found
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end

