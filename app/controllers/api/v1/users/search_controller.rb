module Api::V1::Users
  class SearchController < ApplicationController
    def index
      response = params[:single] ? User.find(user_params) : User.where(user_params)
    
      if response.is_a? UserError
        render json: { error: response.message }, status: response.status
      else
        render json: response
      end
    end

    def user_params
      params.permit(:first_name, :last_name, :email, :gov_id_type, :gov_id_number)
    end
  end
  
end