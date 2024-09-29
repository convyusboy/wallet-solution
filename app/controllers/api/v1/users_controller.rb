class Api::V1::UsersController < ApplicationController
  def index
    users = User.all
    render json: users, status: 200
  end

  def create
    user = User.new(
      username: user_params[:username],
      password: user_params[:password]
    )
    if user.save
      render json: user, status: 200
    else
      render json: { error: "Error creating user." }
    end
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
      :username,
      :password
    ])
  end
end
