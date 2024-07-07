require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.with_campaigns' do
    let!(:user1) { create(:user, campaigns_list: [{ campaign_name: 'campaign1' }]) }
    let!(:user2) { create(:user, campaigns_list: [{ campaign_name: 'campaign2' }]) }

    it 'returns users with specific campaigns' do
      expect(User.with_campaigns(['campaign1'])).to include(user1)
      expect(User.with_campaigns(['campaign1'])).not_to include(user2)
    end
  end
end
