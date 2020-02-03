# frozen_string_literal: true

class PurchasesController < ApplicationController
  def create
    @purchase = Purchase.create(purchase_params)

    if @purchase.valid?
      key = "purchases:#{@purchase.user_id}:"\
            "#{@purchase.content_type}:#{@purchase.content_id}"
      REDIS.set(key, {
                  title: @purchase.content.title,
                  expiry: @purchase.expire_at.to_i
                },
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
