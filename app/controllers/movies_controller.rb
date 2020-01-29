# frozen_string_literal: true

class MoviesController < ApplicationController
  def index
    @movies = paginate(Movie.all)
  end
end
