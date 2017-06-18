class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_current_provider
end
