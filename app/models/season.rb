# frozen_string_literal: true

class Season < ApplicationRecord
  has_many :episodes
  has_many :purchases, as: :content
end
