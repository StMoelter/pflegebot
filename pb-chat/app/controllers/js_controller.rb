# frozen_string_literal: true

class JsController < ApplicationController
  def index
    @session_id = params[:session]
    @session = Session.find_by(uuid: @session_id)
    if @session&.is_deliverable?
      render layout: params[:iframe].blank?
    else
      render status: 401
    end
  end
end
