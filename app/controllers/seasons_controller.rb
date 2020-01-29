# frozen_string_literal: true

class SeasonsController < ApplicationController
  def index
    @seasons = Season.includes(:episodes).order(:created_at, 'episodes.number')
  end
end
