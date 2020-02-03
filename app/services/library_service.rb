# frozen_string_literal: true

class LibraryService < ApplicationService
  attr_reader :user_id
  attr_accessor :library

  def initialize(user_id)
    @user_id = user_id
    @library = []
  end

  def call
    fetch
    sort

    library
  end

  private

  def fetch
    REDIS.scan_each(match: "purchases:#{user.id}:*") do |key|
      library << JSON.parse(REDIS.get(key))
    end
  end

  def sort
    library.sort_by! { |element| element['expiry'] }
  end

  def user
    @user ||= User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    fail!('Invalid user')
  end
end
