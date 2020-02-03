# frozen_string_literal: true

class PurchasesController < ApplicationController
  def create
    @purchase = PurchaseService.call(params)
  end
end
