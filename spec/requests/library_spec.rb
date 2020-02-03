# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Library API', type: :request do
  let!(:user) { create(:user) }

  let!(:movie1) do
    create(:movie,
           title: 'The Shawshank Redemption',
           plot: 'Redemption')
  end

  let!(:movie2) do
    create(:movie,
           title: 'The Godfather',
           plot: 'Godfather')
  end

  before do
    allow(Time).to receive(:now).and_return(Time.now)

    REDIS.set("purchases:#{user.id}:Movie:#{movie1.id}",
              {
                title: movie1.title,
                expiry: 1.day.from_now.to_i
              }.to_json,
              ex: 1.day)

    REDIS.set("purchases:#{user.id}:Movie:#{movie2.id}",
              {
                title: movie2.title,
                expiry: 1.hour.from_now.to_i
              }.to_json,
              ex: 1.hour)
  end

  let(:expected_response) do
    [
      {
        'title' => movie2.title,
        'expiry' => 1.hour.from_now.to_i
      },
      {
        'title' => movie1.title,
        'expiry' => 1.day.from_now.to_i
      }
    ]
  end

  it 'returns library of the user' do
    get user_library_path(user)

    expect(json_response).to eq expected_response
  end
end
