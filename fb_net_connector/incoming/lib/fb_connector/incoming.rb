# frozen_string_literal: true

require 'yaml'

module FbConnector
  class Incoming
    def initialize(amqp_connector)
      @channel = amqp_connector.create_channel
      @queue = @channel.queue('message.incoming')
      @data_connector = FbConnector::Incoming::Data.new(@queue)
      @net_connector = FbConnector::Incoming::Net.new(@data_connector)
    end

    class Net
      def initialize(data_connector)
        @data_connector = data_connector
        listen_for_messages
      end

      def listen_for_messages
        Bot.on :message do |message|
          @data_connector.message(message)
          message.mark_seen
          message.typing_on
        end
      end
    end

    class Data
      def initialize(queue)
        @queue = queue
      end

      def message(fb_message)
        internal_message = {
          id: fb_message.id,
          sender_id: "fb_#{fb_message.sender}",
          sequence: fb_message.seq,
          sent_at: fb_message.sent_at,
          text: fb_message.text,
          attachments: fb_message['attachments'],
          provider: 'fb',
          original_message: YAML.dump(fb_message)
        }
        @queue.publish(internal_message.to_json)
      end
    end
  end
end
