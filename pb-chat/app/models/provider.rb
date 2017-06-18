class Provider < ApplicationRecord
  before_create :add_uuid

  has_many :sessions

  private

  def add_uuid
    self.uuid = SecureRandom.uuid
  end
end
