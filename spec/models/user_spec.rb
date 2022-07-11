require 'rails_helper'

RSpec.describe User do
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

  before do
    User.delete_all
    user1 = User.new(params1)
    user2 = User.new(params2)
    user1.save
    user2.save
  end

  describe '.all' do
    it 'creates user, adds user to memory' do
      expect(User.all.size).to eq(2)
    end
  end

  describe '.where' do
    it 'deletes user, removes from memory' do
      users = User.where(params1)
      expect(users.length).to eq(1)
    end
  end
end
