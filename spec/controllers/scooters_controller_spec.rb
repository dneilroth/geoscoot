require 'rails_helper'

RSpec.describe ScootersController, type: :controller do
  describe 'PUT update' do
    it 'updates a scooter' do
      scooter = create(:scooter)
      put :update, params: { id: scooter.id, lon: -121, lat: 35, battery: 50 }
      scooter.reload
      expect(scooter.lonlat.lon).to eq(-121)
      expect(scooter.lonlat.lat).to eq(35)
      expect(scooter.battery).to eq(50)
    end

    context 'scooter does not exist' do
      it 'returns a 404 status' do
        put :update, params: { id: 'wrong_id' }

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'PUT bulk_unlock' do
    it 'unlocks a group of scooters' do
      scooters = []
      5.times do
        scooters << create(:scooter)
      end

      put :bulk_unlock, params: { ids: scooters.map(&:id) }
      scooters.each(&:reload)

      expect(scooters.first.state).to eq('unlocked')
    end

    context 'scooters do not exist' do
      it 'returns a 404 status' do
        put :bulk_unlock, params: { ids: ['wrong_id'] }

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'GET active' do
    context '5 kilometer radius' do
      let(:lon) { -122.431297 }
      let(:lat) { 37.773972 }
      let!(:scooters_within_radius) do
        [].tap do |arr|
          arr << create(:scooter, lonlat: "POINT(#{lon - 0.0001} #{lat + 0.0001})")
        end
      end
      let!(:scooters_not_within_radius) do
        [].tap do |arr|
          arr << create(:scooter, lonlat: "POINT(#{lon - 1} #{lat + 1})")
        end
      end

      it 'returns the active scooters within a given radius' do
        get :active, params: { lon: lon, lat: lat, radius: 5 }
        scooters = JSON.parse(response.body)
        scooter_ids = scooters.map { |s| s['id'].to_i }

        expect(scooter_ids).to include(*scooters_within_radius.map(&:id))
        expect(scooter_ids).to_not include(*scooters_not_within_radius.map(&:id))
      end

      context 'when scooters are being maintained' do
        before do
          scooters_within_radius.each do |scoot|
            scoot.update(state: 'maintenance')
          end
        end

        it 'does not include scooters being maintained' do
          get :active, params: { lon: lon, lat: lat, radius: 5 }
          scooters = JSON.parse(response.body)
          expect(scooters).to be_empty
        end
      end

      context 'when scooters are in use' do
        before do
          scooters_within_radius.each do |scoot|
            scoot.update(state: 'unlocked')
          end
        end

        it 'does not include scooters being used by other customers' do
          get :active, params: { lon: lon, lat: lat, radius: 5 }
          scooters = JSON.parse(response.body)
          expect(scooters).to be_empty
        end
      end
    end
  end
end
