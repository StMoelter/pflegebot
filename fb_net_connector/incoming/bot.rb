# frozen_string_literal: true

require 'bunny'
require 'facebook/messenger'
require 'json'

include Facebook::Messenger

conn = Bunny.new('amqp://guest:guest@rabbitmq:5672')
conn.start
channel = conn.create_channel
message_queue = channel.queue('fb.message.incoming')

Bot.on :message do |message|
  message_queue.publish(message.to_json)
  message.mark_seen
end
