class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all.includes(:skills)

    render json: @users
  end

  # GET /users/0x01d3b5eaa2e305a1553f0e2612353c94e597449e (uPort address)
  def show
    @user = User.find_or_create_by!(uport_address: params[:uport_address])
    render json: @user.as_json(confirmations: true)
    UpdateProfile.perform_async @user.to_param # update profile info from uPort async
  end
end
