# frozen_string_literal: true

class MessagesController < ApplicationController
  def index
    @session = params[:session] || SecureRandom.uuid
  end
end
