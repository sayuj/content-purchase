# frozen_string_literal: true

class PurchaseService < ApplicationService
  attr_reader :params, :purchase

  def initialize(params)
    @params = params
  end

  def call
    @purchase = Purchase.create(purchase_params)

    cache if @purchase.valid?

    @purchase
  end

  private

  def cache
    REDIS.set(cache_key, cache_data, ex: cache_expiry)
  end

  def cache_key
    "purchases:#{purchase.user_id}:"\
      "#{purchase.content_type}:"\
      "#{purchase.content_id}"
  end

  def cache_data
    data = {
      title: purchase.content.title,
      expiry: purchase.expire_at.to_i,
      content_type: purchase.content_type
    }

    data[:number] = purchase.content.number if purchase.content.is_a?(Season)

    data
  end

  def cache_expiry
    Purchase::EXPIRY_DURATION
  end

  def purchase_params
    @purchase_params ||= begin
                           purchase_params = params.permit(
                             :user_id,
                             :content_type,
                             :content_id,
                             :purchase_option_id
                           )
                           purchase_params[:content_type].capitalize!
                           purchase_params
                         end
  end
end
