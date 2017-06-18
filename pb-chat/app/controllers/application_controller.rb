# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  attr_reader :current_provider, :token

  protected

  def check_current_provider
    load_current_provider if @provider_loaded.blank?
    return if current_provider&.active.present?
    render plain: 'Provider nicht gefunden oder inaktiv', status: 403
  end

  def load_current_provider
    @provider_loaded = true
    @token = params[:token] || request.headers['X-PflegeBot-Provider'].to_s
    @current_provider = Provider.find_by(uuid: @token)
  end
end
