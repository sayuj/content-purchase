# frozen_string_literal: true

class LibrariesController < ApplicationController
  def show
    @library = []
    REDIS.scan_each(match: "purchases:#{user.id}:*") do |key|
      @library << JSON.parse(REDIS.get(key))
    end

    @library.sort_by! { |element| element[:expiry] }
    render json: @library
  end

  def user
    User.find(params[:user_id])
  end
end
