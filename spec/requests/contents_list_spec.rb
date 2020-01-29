# frozen_string_literal: true

# frozen_string_literal=>true

require 'rails_helper'

RSpec.describe 'Contents list API', type: :request do
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
           number: 1,
           plot: 'Breaking Bad',
           season: season2)
  end

  let!(:season_2_episode2) do
    create(:episode,
           title: 'Grilled',
           number: 2,
           plot: 'Breaking Bad',
           season: season2)
  end

  let(:expected_response) do
    {
      'movies' => [
        {
          'id' => movie1.id,
          'title' => movie1.title,
          'plot' => movie1.plot
        },
        {
          'id' => movie2.id,
          'title' => movie2.title,
          'plot' => movie2.plot
        }
      ],
      'seasons' =>
            [
              {
                'id' => season1.id,
                'title' => season1.title,
                'number' => season1.number,
                'plot' => season1.plot,
                'episodes' => [
                  {
                    'title' => season_1_episode1.title,
                    'plot' => season_1_episode1.plot,
                    'number' => season_1_episode1.number
                  },
                  {
                    'title' => season_1_episode2.title,
                    'plot' => season_1_episode2.plot,
                    'number' => season_1_episode2.number
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
                    'title' => season_2_episode1.title,
                    'plot' => season_2_episode1.plot,
                    'number' => season_2_episode1.number
                  },
                  {
                    'title' => season_2_episode2.title,
                    'plot' => season_2_episode2.plot,
                    'number' => season_2_episode2.number
                  }
                ]
              }
            ]
    }
  end

  it 'returns list of movies and seasons in the order of creation' do
    get contents_path

    expect(json_response).to eq expected_response
  end

  it 'returns list of episodes in the order of number' do
    get contents_path

    seasons = json_response['seasons']

    expect(seasons.first['episodes'].first['number']).to eq 1
    expect(seasons.first['episodes'].second['number']).to eq 2
    expect(seasons.second['episodes'].first['number']).to eq 1
    expect(seasons.second['episodes'].second['number']).to eq 2
  end

  context 'pagination' do
    it 'paginate the result'
  end
end
