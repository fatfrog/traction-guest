class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: user.attributes, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:first_name, :last_name, :email, :gov_id_number, :gov_id_type)
  end
end
