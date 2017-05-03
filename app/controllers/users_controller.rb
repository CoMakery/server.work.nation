class UsersController < ApplicationController
  # index:
  # /users
  #
  # search:
  # /users?perspective=0xff902fc776998336a213c5c6050a4572b7453643&skill=UX&depth=4
  def index
    if params[:perspective]
      trust_graph_root_user = User.find_by(uport_address: params[:perspective])
      @users = trust_graph_root_user.search_trust_graph(params[:skill], depth: params[:depth])
    else
      @users = User.limit(200).includes(:skill_claims)
    end

    render json: @users
  end

  # GET /users/0x01d3b5eaa2e305a1553f0e2612353c94e597449e (uPort address)
  def show
    @user = User.find_or_create_by!(uport_address: params[:uport_address])
    render json: @user.as_json(confirmations: true)
    UpdateProfile.perform_async @user.to_param # update profile info from uPort async
  end
end
