# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Purchase API', type: :request do
  let!(:user) { create(:user) }
  let!(:movie1) do
    create(:movie,
           title: 'The Shawshank Redemption',
           plot: 'Redemption')
  end

  let!(:season1) do
    create(:season,
           title: 'Breaking Bad',
           number: 1,
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

  let!(:purchase_option) { create(:purchase_option) }

  context 'movie purchase' do
    let(:params) do
      {
        "user_id": user.id,
        "content_type": 'movie',
        "content_id": movie1.id,
        "purchase_option_id": purchase_option.id
      }
    end
    context 'fresh purchase' do
      it 'performs a purchase' do
        expect { post purchases_path, params: params }
          .to change(Purchase, :count).by(1)
      end

      it 'responds with a success message' do
        post purchases_path, params: params
        expect(json_response['message']).to eq 'success'
      end
    end

    context 'duplicate purchase' do
      before do
        post purchases_path, params: params
      end

      it 'fails the purchase' do
        expect { post purchases_path, params: params }
          .to change(Purchase, :count).by(0)
      end

      it 'responds with an error message' do
        post purchases_path, params: params
        expect(json_response['errors']).to eq ['already purchased']
      end
    end

    context 'repurchase after expiry' do
      before do
        create(:purchase,
               user: user,
               content: movie1,
               purchase_option_id: purchase_option.id,
               expire_at: 1.day.ago)
      end

      it 'performs a purchase' do
        expect { post purchases_path, params: params }
          .to change(Purchase, :count).by(1)
      end

      it 'responds with a success message' do
        post purchases_path, params: params
        expect(json_response['message']).to eq 'success'
      end
    end
  end

  context 'season purchase' do
    let(:params) do
      {
        "user_id": user.id,
        "content_type": 'season',
        "content_id": season1.id,
        "purchase_option_id": purchase_option.id
      }
    end
    context 'fresh purchase' do
      it 'performs a purchase' do
        expect { post purchases_path, params: params }
          .to change(Purchase, :count).by(1)
      end

      it 'responds with a success message' do
        post purchases_path, params: params
        expect(json_response['message']).to eq 'success'
      end
    end

    context 'duplicate purchase' do
      before do
        post purchases_path, params: params
      end

      it 'fails the purchase' do
        expect { post purchases_path, params: params }
          .to change(Purchase, :count).by(0)
      end

      it 'responds with an error message' do
        post purchases_path, params: params
        expect(json_response['errors']).to eq ['already purchased']
      end
    end

    context 'repurchase after expiry' do
      before do
        create(:purchase, user: user,
                          content: season1,
                          purchase_option_id: purchase_option.id,
                          expire_at: 1.day.ago)
      end

      it 'performs a purchase' do
        expect { post purchases_path, params: params }
          .to change(Purchase, :count).by(1)
      end

      it 'responds with a success message' do
        post purchases_path, params: params
        expect(json_response['message']).to eq 'success'
      end
    end
  end

  context 'invalid params' do
    context 'user_id is not valid' do
      let(:params) do
        {
          "user_id": '100',
          "content_type": 'movie',
          "content_id": movie1.id,
          "purchase_option_id": purchase_option.id
        }
      end

      it 'fails the purchase' do
        expect { post purchases_path, params: params }
          .to change(Purchase, :count).by(0)
      end

      it 'responds with an error message' do
        post purchases_path, params: params
        expect(json_response['errors']).to eq ['User must exist']
      end
    end

    context 'content_type & content_id is not valid' do
      let(:params) do
        {
          "user_id": user.id,
          "content_type": 'movie',
          "content_id": 'abc',
          "purchase_option_id": purchase_option.id
        }
      end

      it 'fails the purchase' do
        expect { post purchases_path, params: params }
          .to change(Purchase, :count).by(0)
      end

      it 'responds with an error message' do
        post purchases_path, params: params
        expect(json_response['errors']).to eq ['Content must exist']
      end
    end

    context 'purchase_option_id not valid' do
      let(:params) do
        {
          "user_id": user.id,
          "content_type": 'movie',
          "content_id": movie1.id,
          "purchase_option_id": 'abc'
        }
      end

      it 'fails the purchase' do
        expect { post purchases_path, params: params }
          .to change(Purchase, :count).by(0)
      end

      it 'responds with an error message' do
        post purchases_path, params: params
        expect(json_response['errors']).to eq ['Purchase option must exist']
      end
    end
  end

  context 'cache movie purchases in Redis' do
    let(:params) do
      {
        "user_id": user.id,
        "content_type": 'movie',
        "content_id": movie1.id,
        "purchase_option_id": purchase_option.id
      }
    end

    before do
      allow(Time).to receive(:now).and_return(Time.now)
    end

    it 'caches the purchase in Redis' do
      expect_any_instance_of(Redis).to receive(:set).with(
        "purchases:#{user.id}:Movie:#{movie1.id}",
        {
          title: movie1.title,
          expiry: Purchase::EXPIRY_DURATION.from_now.to_i
        },
        ex: Purchase::EXPIRY_DURATION
      )

      post purchases_path, params: params
    end
  end

  context 'cache season purchases in Redis' do
    let(:params) do
      {
        "user_id": user.id,
        "content_type": 'season',
        "content_id": season1.id,
        "purchase_option_id": purchase_option.id
      }
    end

    before do
      allow(Time).to receive(:now).and_return(Time.now)
    end

    it 'caches the purchase in Redis' do
      expect_any_instance_of(Redis).to receive(:set).with(
        "purchases:#{user.id}:Season:#{season1.id}",
        {
          title: season1.title,
          expiry: Purchase::EXPIRY_DURATION.from_now.to_i
        },
        ex: Purchase::EXPIRY_DURATION
      )

      post purchases_path, params: params
    end
  end
end
