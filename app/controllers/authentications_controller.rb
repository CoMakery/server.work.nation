class AuthenticationsController < ApplicationController
  def new
  end

  def create
    session[:uport_user_id] = params[:uport_user_id]
    redirect_to root_path
  end
end
