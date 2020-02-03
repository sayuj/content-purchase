# frozen_string_literal: true

class LibrariesController < ApplicationController
  def show
    @library = LibraryService.call(params[:user_id])
  end
end
