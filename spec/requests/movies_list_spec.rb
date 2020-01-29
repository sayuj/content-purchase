# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movies list API', type: :request do
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

  let(:expected_response) do
    [
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
    ]
  end

  it 'returns list of movies in the order of creation' do
    get movies_path

    expect(json_response).to eq expected_response
  end

  context 'pagination' do
    before do
      10.times.each { create(:movie) }
    end

    it 'paginates the result' do
      get movies_path, params: { per_page: 2 }
      expect(json_response.count).to eq 2

      get movies_path, params: { per_page: 5 }
      expect(json_response.count).to eq 5
    end
  end
end
