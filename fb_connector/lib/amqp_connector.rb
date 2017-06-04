# frozen_string_literal: true

class AmqpConnector
  attr_reader :message_queue, :conn

  def initialize(host = '127.0.0.1')
    connect(host)
  end

  def connect(host = '127.0.0.1')
    failure_counter = 0
    @conn = Bunny.new("amqp://guest:guest@#{host}:5672")
    @conn.start
    @channel = @conn.create_channel
    @message_queue = @channel.queue('internal.message.incoming')
  rescue Bunny::TCPConnectionFailedForAllHosts => _e
    failure_counter += 1
    raise 'Too many network errors' if failure_counter > 100
    sleep 1
    retry
  rescue Bunny::NetworkFailure => _e
    failure_counter += 1
    raise 'Too many network errors' if failure_counter > 100
    ch.maybe_kill_consumer_work_pool!
    sleep 2
    retry
  end
end
