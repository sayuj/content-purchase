# frozen_string_literal: true

if @purchase.valid?
  json.message 'success'
else
  json.errors @purchase.errors.full_messages
end
