class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: user.attributes, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    response = User.find(delete_user_params, return_object: true)

    if response.is_a? UserError
      render json: { error: response.message }, status: response.status
    else
      response.first.delete
      head :no_content, status: :ok
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:first_name, :last_name, :email, :gov_id_number, :gov_id_type)
  end

  def delete_user_params
    params.permit(:first_name, :last_name, :email, :gov_id_number, :gov_id_type)
  end
end
