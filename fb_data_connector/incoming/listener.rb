# frozen_string_literal: true

require 'bunny'
require 'json'

begin
  conn = Bunny.new('amqp://guest:guest@127.0.0.1:5672')
  conn.start
  channel = conn.create_channel
  message_input_queue = channel.queue('fb.message.incoming')
  message_output_queue = channel.queue('message.incoming')

  message_input_queue.subscribe(blocking: true) do |_delivery_info, _metadata, payload|
    fb_message = JSON.parse payload
    internal_message = {
      id: fb_message['id'],
      sender_id: "fb_#{fb_message.dig('sender', 'id')}",
      sequence: fb_message['seq'],
      sent_at: fb_message['sent_at'],
      text: fb_message['text'],
      attachments: fb_message['attachments'],
      provider: 'fb'
    }
    message_output_queue.publish(internal_message.to_json)
  end

  Thread.list.each{ |t| t.join unless t == Thread.current }

rescue Bunny::TCPConnectionFailedForAllHosts => _e
  sleep 1
  retry
rescue Bunny::NetworkFailure => _e
  ch.maybe_kill_consumer_work_pool!
  sleep 2
  retry
end
