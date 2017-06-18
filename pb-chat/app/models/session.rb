class Session < ApplicationRecord
  VALID_FOR = 12.hours
  before_create :set_values

  belongs_to :provider

  private

  def set_values
    self.uuid = SecureRandom.uuid
    self.activated = false
    self.active_until = Time.now.in_time_zone('UTC') + VALID_FOR
  end
end
