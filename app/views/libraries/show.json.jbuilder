# frozen_string_literal: true

json.array!(@library) do |lib|
  json.title lib['title']
  json.expiry lib['expiry']
  json.content_type lib['content_type']
  json.number lib['number'] if lib['content_type'] == 'Season'
end
