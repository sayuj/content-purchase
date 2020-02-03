# frozen_string_literal: true

class ApplicationService
  def self.call(*args)
    new(*args).call
  end

  # Implement in derived classes
  def initialize(*_args); end
end
