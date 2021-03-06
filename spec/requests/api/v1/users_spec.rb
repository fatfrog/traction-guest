require 'rails_helper'

RSpec.describe User, type: :request do
  let(:params1) do
    {
      user: {
        first_name: 'Bill',
        last_name: 'Bailey',
        gov_id_type: 'Drivers License',
        gov_id_number: '123456-ABC'
      }
    }
  end

  let(:params2) do
    {
      user: {
        first_name: 'Bella',
        last_name: 'Bailey',
        gov_id_type: 'Drivers License',
        gov_id_number: '123456-XYZ'
      }
    }
  end

  let(:no_last_name_params) do
    {
      user: {
        first_name: 'Bill'
      }
    }
  end

  let(:no_first_name_params) do
    {
      user: {
        last_name: 'Bailey'
      }
    }
  end

  let(:incorrect_email_params) do
    {
      user: {
        first_name: 'Bill',
        last_name: 'Bailey',
        email: 'bill@bailey'
      }
    }
  end

  before { User.delete_all }

  describe 'POST /create' do
    it 'creates user, adds user to memory' do
      expect do
        post '/api/v1/users', params: params1
      end.to change { User.all.count }.from(0).to(1)   

      expect(response).to have_http_status(:created)
    end

    it 'fails without first name' do
      post '/api/v1/users', params: no_first_name_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ 'errors' => { 'first_name' => ["can't be blank"] } })
    end

    it 'fails without last name' do
      post '/api/v1/users', params: no_last_name_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ 'errors' => { 'last_name' => ["can't be blank"] } })
    end

    it 'fails without correct email format' do
      post '/api/v1/users', params: incorrect_email_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ 'errors' => { 'email' => ['is invalid'] } })
    end

    it 'fails for duplicate records' do
      post '/api/v1/users', params: params1
      post '/api/v1/users', params: params1

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ 'errors' => { 'not_unique' => ['Record is not unique'] } })
    end
  end

  describe 'DELETE /users' do
    it 'deletes user, removes from memory' do
      User.delete_all
      post '/api/v1/users', params: params1
      expect do
        delete '/api/v1/users?first_name=Bill'
      end.to change { User.all.count }.from(1).to(0)
      expect(response).to have_http_status(:no_content)
    end

    it 'returns unprocessable_entity if there are multiple matches' do
      post '/api/v1/users', params: params1
      post '/api/v1/users', params: params2
      expect do
        delete '/api/v1/users', params: { user: { last_name: 'Bailey' } }
      end.not_to change { User.all.count }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns not_found if there are no matches' do
      post '/api/v1/users', params: params1
      expect do
        delete '/api/v1/users?first_name=Wrong_Name'
      end.not_to change { User.all.count }
      expect(response).to have_http_status(:not_found)
    end
  end
end
