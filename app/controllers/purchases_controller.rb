# frozen_string_literal: true

class PurchasesController < ApplicationController
  def create
    @purchase = Purchase.create(purchase_params)
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
