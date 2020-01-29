# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_default_response_format

  protected

  def set_default_response_format
    request.format = :json unless params[:format]
  end

  def paginate(collection)
    collection.page(params[:page] || 1).per(params[:per_page] || 10)
  end
end
