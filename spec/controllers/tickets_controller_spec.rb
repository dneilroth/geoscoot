require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  describe 'POST create' do
    it 'creates a maintenance ticket' do
      scooter = create(:scooter, state: 'unlocked')
      post :create, params: { scooter_id: scooter.id, description: 'fix light' }
      scooter.reload

      expect(scooter.tickets.count).to eq(1)
      expect(scooter.tickets.first.description).to eq('fix light')
    end
  end

  context 'scooter does not exist' do
    it 'returns a 404 status' do
      post :create, params: { scooter_id: 'wrong_id' }

      expect(response.status).to eq(404)
    end
  end
end
