# frozen_string_literal: true

class PurchasesController < ApplicationController
  def create
    @purchase = Purchase.create(purchase_params)

    if @purchase.valid?
      key = "purchases:#{@purchase.user_id}:"\
            "#{@purchase.content_type}:#{@purchase.content_id}"
      data = {
        title: @purchase.content.title,
        expiry: @purchase.expire_at.to_i,
        content_type: @purchase.content_type
      }
      if @purchase.content.is_a?(Season)
        data[:number] = @purchase.content.number
      end

      REDIS.set(key, data,
                ex: Purchase::EXPIRY_DURATION)
    end
  end

  def purchase_params
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
