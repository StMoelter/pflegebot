# frozen_string_literal: true

# require 'bunny'
require 'facebook/messenger'
require 'json'
require_relative 'lib/amqp_connector'
require_relative 'lib/config_provider'
require_relative 'lib/fb_connector'

include Facebook::Messenger

Facebook::Messenger.configure do |config|
  config.provider = ConfigProvider.new
end

amqp_connector = AmqpConnector.new('rabbitmq')
# amqp_connector = AmqpConnector.new('127.0.0.1')
FbConnector::Incoming.new(amqp_connector.conn)
FbConnector::Outgoing.new(amqp_connector.conn)
