module V1
  class SessionsController < ApiController
    before_action :check_current_provider
    def create
      @session = current_provider.sessions.create!
      render json: { uuid: @session.uuid }
    end
  end
end
