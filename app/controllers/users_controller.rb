# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # GET /users
  # Fetches all users
  def index
    @users = User.all
    render json: @users
  end

  # POST /users
  # Creates a new user
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # GET /users/filter
  # Filters users by campaign names
  def filter
    campaign_names = params[:campaign_names].split(',')
    @users = User.with_campaigns(campaign_names)
    render json: @users
  end

  private

  # Strong parameters for creating a user
  def user_params
    params.require(:user).permit(:name, :email, campaigns_list: [])
  end
end
