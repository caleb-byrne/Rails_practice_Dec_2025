require 'rails_helper'
require 'http'

describe 'Actors API' do
  # Base URL for your API
  BASE_URL = 'http://localhost:3001/api/v1'

  before(:each) do
    # Reset database before each test
    Actor.delete_all
    
    # Create fresh test data
    test_data = [
      { name: 'Tom Holland', country: 'United Kingdom' },
      { name: 'Robert Downey Jr.', country: 'United States' },
      { name: 'Scarlett Johansson', country: 'United States' },
      { name: 'Johnny Depp', country: 'United States' },
      { name: 'Margot Robbie', country: 'Australia' }
    ]
    
    test_data.each { |data| Actor.create!(data) }
  end

  describe 'GET /api/v1/actors', :tc_actors do
      it 'tc_get_actors_01 returns a 200 status code', :tc_get_actors_01, :tc_actors do
        response = HTTP.get("#{BASE_URL}/actors")
        expect(response.status).to eq(200)
        puts "tc_get_actors_01 - Status: #{response.status}"
      end

      it 'tc_get_actors_02 returns an array of actors', :tc_get_actors_02, :tc_actors do
        response = HTTP.get("#{BASE_URL}/actors")
        body = JSON.parse(response.body)
        expect(body).to be_a(Array)
        puts "tc_get_actors_02 - Status: #{response.status}"
      end

      it 'tc_get_actors_03 each actor has name and country', :tc_get_actors_03, :tc_actors do
        response = HTTP.get("#{BASE_URL}/actors")
        body = JSON.parse(response.body)
        body.each do |actor|
          expect(actor).to have_key('name')
          expect(actor).to have_key('country')
        end
        puts "tc_get_actors_03 - Status: #{response.status}"
      end
  end

  describe 'GET /api/v1/actors/:id', :tc_actors do
      it 'tc_get_actors_id_01 returns a 200 status code', :tc_get_actors_id_01, :tc_actors do
        response = HTTP.get("#{BASE_URL}/actors/#{Actor.all[0].id}")
        expect(response.status).to eq(200)
        puts "tc_get_actors_id_01 - Status: #{response.status}"
      end

      it 'tc_get_actors_id_02 returns the actor with correct structure', :tc_get_actors_id_02, :tc_actors do
        response = HTTP.get("#{BASE_URL}/actors/#{Actor.all[0].id}")
        body = JSON.parse(response.body)
        expect(body).to have_key('id')
        expect(body).to have_key('name')
        expect(body).to have_key('country')
        puts "tc_get_actors_id_02 - Status: #{response.status}"
      end
  end

  describe 'POST /api/v1/actors', :tc_actors do
      it 'tc_post_actors_01 returns a 201 status code', :tc_post_actors_01, :tc_actors do
        response = HTTP.post("#{BASE_URL}/actors", json: {
          actor: {
            name: 'Tom Cruise',
            country: 'United States'
          }
        })
        expect(response.status).to eq(201)
        puts "tc_post_actors_01 - Status: #{response.status}"
      end

      it 'tc_post_actors_02 returns the created actor', :tc_post_actors_02, :tc_actors do
        response = HTTP.post("#{BASE_URL}/actors", json: {
          actor: {
            name: 'Johnny Depp',
            country: 'United States'
          }
        })
        body = JSON.parse(response.body)
        expect(body['name']).to eq('Johnny Depp')
        expect(body['country']).to eq('United States')
        puts "tc_post_actors_02 - Status: #{response.status}"
      end
  end

  describe 'PATCH /api/v1/actors/:id', :tc_actors do
    it 'tc_patch_actors_id_01 returns a 200 status code', :tc_patch_actors_id_01, :tc_actors do
        response = HTTP.patch("#{BASE_URL}/actors/#{Actor.all[0].id}", json: {
          actor: {
            name: 'Updated Name'
          }
        })
        expect(response.status).to eq(200)
        puts "tc_patch_actors_id_01 - Status: #{response.status}"
      end

      it 'tc_patch_actors_id_02 returns the updated actor', :tc_patch_actors_id_02, :tc_actors do
        response = HTTP.patch("#{BASE_URL}/actors/#{Actor.all[1].id}", json: {
          actor: {
            name: 'New Actor Name'
          }
        })
        body = JSON.parse(response.body)
        expect(body['name']).to eq('New Actor Name')
        puts "tc_patch_actors_id_02 - Status: #{response.status}"
      end
  end

  describe 'DELETE /api/v1/actors/:id', :tc_actors do
       it 'tc_delete_actors_id_01 returns a 204 status code', :tc_delete_actors_id_01, :tc_actors do
        response = HTTP.delete("#{BASE_URL}/actors/#{Actor.all[2].id}")
        expect(response.status).to eq(204)
        puts "tc_delete_actors_id_01 - Status: #{response.status}"
      end
    context 'Negative cases' do
      it 'tc_delete_actors_id_02 actor is no longer accessible', :tc_delete_actors_id_02, :tc_actors do
        actor_id = Actor.all[3].id
        HTTP.delete("#{BASE_URL}/actors/#{actor_id}")
        response = HTTP.get("#{BASE_URL}/actors/#{actor_id}")
        get_response = JSON.parse(response.body)
        expect(response.status).to eq(404)
        expect(get_response).to have_key('error')
        puts "tc_delete_actors_id_02 - Status: #{response.status}"
      end
    end
  end
end
