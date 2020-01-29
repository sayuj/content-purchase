# frozen_string_literal: true

class Movie < ApplicationRecord
  has_many :purchases, as: :content
end
