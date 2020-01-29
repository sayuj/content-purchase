# frozen_string_literal: true

# frozen_string_literal=>true

require 'rails_helper'

RSpec.describe 'Seasons list API', type: :request do
  let!(:season1) do
    create(:season,
           title: 'Breaking Bad',
           number: 1,
           plot: 'Breaking Bad')
  end

  let!(:season2) do
    create(:season,
           title: 'Breaking Bad',
           number: 2,
           plot: 'Breaking Bad')
  end

  let!(:season_1_episode1) do
    create(:episode,
           title: 'Pilot',
           number: 1,
           plot: 'Breaking Bad',
           season: season1)
  end

  let!(:season_1_episode2) do
    create(:episode,
           title: 'Cat\'s in the Bad',
           number: 2,
           plot: 'Breaking Bad',
           season: season1)
  end

  let!(:season_2_episode1) do
    create(:episode,
           title: 'Seven Thirty-Seven',
           number: 2,
           plot: 'Breaking Bad',
           season: season2)
  end

  let!(:season_2_episode2) do
    create(:episode,
           title: 'Grilled',
           number: 1,
           plot: 'Breaking Bad',
           season: season2)
  end

  let(:expected_response) do
    [
      {
        'id' => season1.id,
        'title' => season1.title,
        'number' => season1.number,
        'plot' => season1.plot,
        'episodes' => [
          {
            'title' => season_1_episode1.title,
            'number' => season_1_episode1.number,
            'plot' => season_1_episode1.plot
          },
          {
            'title' => season_1_episode2.title,
            'number' => season_1_episode2.number,
            'plot' => season_1_episode2.plot
          }
        ]
      },
      {
        'id' => season2.id,
        'title' => season2.title,
        'number' => season2.number,
        'plot' => season2.plot,
        'episodes' => [

          {
            'title' => season_2_episode2.title,
            'number' => season_2_episode2.number,
            'plot' => season_2_episode2.plot
          },
          {
            'title' => season_2_episode1.title,
            'number' => season_2_episode1.number,
            'plot' => season_2_episode1.plot
          }
        ]
      }
    ]
  end

  it 'returns list of seasons in the order of creation' do
    get seasons_path
    expect(json_response).to eq expected_response
  end

  it 'returns list of episodes in the order of number' do
    get seasons_path

    expect(json_response.first['episodes'].first['number']).to eq 1
    expect(json_response.first['episodes'].second['number']).to eq 2
    expect(json_response.second['episodes'].first['number']).to eq 1
    expect(json_response.second['episodes'].second['number']).to eq 2
  end

  context 'pagination' do
    it 'paginates the result'
  end
end
