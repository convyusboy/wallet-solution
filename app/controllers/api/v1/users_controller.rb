class Api::V1::UsersController < ApplicationController
  include ApplicationHelper
  def index
    users = User.all
    render json: users, status: 200
  end

  def create
    user = User.new(
      email: user_params[:email],
      password: encrypt(user_params[:password])
    )
    user.save!
    user.password = decrypt(user.password)
    render json: user, status: 200
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def show
    user = User.find(params[:id])
    if user
      render json: user, status: 200
    else
      render json: { error: "User Not Found." }
    end
  end

  private
  def user_params
    params.require(:user).permit([
      :email,
      :password
    ])
  end
end
