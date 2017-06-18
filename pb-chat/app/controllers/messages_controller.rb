# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :check_current_provider

  def index
    @session = current_provider.sessions.create!
    @session_id = @session.uuid
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{current_provider.host}"
  end
end
