class UsersSearchController < ApplicationController
  def index
    users = User.where(params[:users_search])
    if users.any?
      render json: { users: users }, status: :ok
    else
      render json: 'No records found.', status: :not_found
    end
  end
end
