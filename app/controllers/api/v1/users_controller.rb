class Api::V1::UsersController < ApplicationController
  respond_to :json

  before_action :find_user, only: [:show, :update, :destroy]

  def show
    respond_with @user
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: 201, location: [:api, @user]
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def destroy
    @user.destroy
    head 204
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
