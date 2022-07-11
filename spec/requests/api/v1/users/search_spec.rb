require 'rails_helper'

RSpec.describe Api::V1::Users::SearchController, type: :request do
  describe 'GET /user/search' do
    let(:headers) { { "Content-Type" => "application/json" } }

    let(:params1) do
      {
        first_name: 'Bill',
        last_name: 'Bailey',
        gov_id_type: 'Drivers License',
        gov_id_number: '123456-ABC'
      }
    end

    let(:params2) do
      {
        first_name: 'Bella',
        last_name: 'Bailey',
        gov_id_type: 'Drivers License',
        gov_id_number: '123456-XYZ'
      }
    end
  
    let(:search_params) { { last_name: 'Bailey' }.to_query }

    before do
      User.delete_all
      User.new(params1).save
      User.new(params2).save
    end

    it 'returns all records' do
      get '/api/v1/users/search', params: search_params, headers: headers

      expect(JSON.parse(response.body).length).to eq(2)
    end

    it 'returns too many records error' do
      get "/api/v1/users/search?single=true&#{search_params}", headers: headers

      expect(JSON.parse(response.body)).to eq({ "error" => "Too many records." })
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end