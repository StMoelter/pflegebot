# frozen_string_literal: true

require 'bunny'
require 'yaml'

failure_counter = 0
begin
  conn = Bunny.new('amqp://guest:guest@127.0.0.1:5672')
  # conn = Bunny.new('amqp://guest:guest@rabbitmq:5672')
  conn.start
  channel = conn.create_channel
  message_input_queue = channel.queue('message.incoming')
  fb_message_output_queue = channel.queue('fb.message.outgoing')
  sc_message_output_queue = channel.queue('sc.message.outgoing')

  message_input_queue.subscribe do |_delivery_info, _metadata, payload|
    # rubocop:disable Security/YAMLLoad
    message = YAML.load payload
    # rubocop:enable Security/YAMLLoad
    message[:text] = "Umgekehrt: #{message[:text].reverse}"
    provider = message[:provider]
    queue = nil
    if provider == 'fb'
      queue = fb_message_output_queue
    elsif provider == 'sc'
      queue = sc_message_output_queue
    else
      raise "Unknown Provider #{provider}"
    end
    queue&.publish(YAML.dump(message))
  end

  Thread.list.each { |t| t.join unless t == Thread.current }
rescue Bunny::TCPConnectionFailedForAllHosts => _e
  failure_counter += 1
  raise 'Too many network errors' if failure_counter > 50
  sleep 1
  retry
rescue Bunny::NetworkFailure => _e
  failure_counter += 1
  raise 'Too many network errors' if failure_counter > 50
  sleep 1
  retry
end
