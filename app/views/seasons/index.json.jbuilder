# frozen_string_literal: true

json.array!(@seasons) do |season|
  json.id season.id
  json.title season.title
  json.number season.number
  json.plot season.plot
  json.episodes season.episodes, :title, :number, :plot
end
