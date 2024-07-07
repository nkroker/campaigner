require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:user) }

    it 'creates a new user' do
      expect {
        post :create, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
    end

    it 'returns the created user' do
      post :create, params: { user: valid_attributes }
      expect(response.body).to include(valid_attributes[:name])
    end
  end

  describe 'GET #filter' do
    let!(:user) { create(:user, campaigns_list: [{ campaign_name: 'campaign1' }]) }

    it 'filters users by campaign name' do
      get :filter, params: { campaign_names: 'campaign1' }, format: :json
      expect(response.body).to include(user.name)
    end
  end
end
