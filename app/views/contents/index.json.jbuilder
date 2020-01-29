# frozen_string_literal: true

json.movies do
  json.array!(@movies, :id, :title, :plot)
end

json.seasons do
  json.array!(@seasons) do |season|
    json.id season.id
    json.title season.title
    json.number season.number
    json.plot season.plot
    json.episodes season.episodes, :title, :number, :plot
  end
end
