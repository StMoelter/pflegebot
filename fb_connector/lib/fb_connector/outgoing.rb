# frozen_string_literal: true

module FbConnector
  class Outgoing
    def initialize(amqp_connector)
      @channel = amqp_connector.create_channel
      @queue = @channel.queue('fb.message.outgoing')
      @data_connector = FbConnector::Outgoing::Data.new
      @net_connector = FbConnector::Outgoing::Net.new
      subscribe
    end

    private

    def subscribe
      @queue.subscribe do |_delivery_info, _metadata, payload|
        # rubocop:disable Security/YAMLLoad
        internal_message = YAML.load payload
        # rubocop:enable Security/YAMLLoad
        fb_message = @data_connector.message(internal_message)
        @net_connector.send_message(fb_message)
      end
    end

    class Data
      def message(fb_message)
        fb_message
      end
    end

    class Net
      def send_message(internal_message)
        # rubocop:disable Security/YAMLLoad
        fb_message = YAML.load(internal_message[:original_message])
        # rubocop:enable Security/YAMLLoad
        fb_message.reply(text: internal_message[:text])
      end
    end
  end
end
