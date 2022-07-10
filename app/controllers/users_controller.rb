class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: user.attributes, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    users = User.where(params[:user], attributes_format: false)
    if users.none?
      render json: { errors: 'User not found', status: :not_found }
    elsif users.many?
      render json: { errors: 'User not unique', status: :unprocessable_entity }
    else
      users.first.delete
      head :no_content, status: :ok
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:first_name, :last_name, :email, :gov_id_number, :gov_id_type)
  end
end
