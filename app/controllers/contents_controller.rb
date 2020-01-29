# frozen_string_literal: true

class ContentsController < ApplicationController
  def index
    @movies = Movie.all
    @seasons = Season.includes(:episodes).all
  end
end
