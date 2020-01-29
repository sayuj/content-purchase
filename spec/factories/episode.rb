# frozen_string_literal: true

FactoryBot.define do
  factory :episode do
    title { 'Pilot' }
    number { 1 }
    plot { 'Breaking Bad' }
  end
end
