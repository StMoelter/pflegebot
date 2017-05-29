require 'bunny'
require 'json'

conn = Bunny.new('amqp://guest:guest@rabbitmq:5672')
conn.start
channel = conn.create_channel
message_input_queue = channel.queue('fb.message.incoming')
message_output_queue = channel.queue('message.incoming')

message_input_queue.subscribe do |_delivery_info, _metadata, payload|
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
