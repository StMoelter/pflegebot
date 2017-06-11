# frozen_string_literal: true

# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel
  def subscribed
    @session = params[:session] || SecureRandom.uuid
    stream_from "messages-#{@session}" # point to uniq channel
    @queue = AmqpConnector.new(BUNNY_HOST).conn.create_channel.queue('message.incoming')
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # send to queue
    # activate message read and typing

    # Broadcast shall be called message from amqp queue
    ActionCable.server.broadcast("messages-#{@session}", message: render_message(data['message']))
    internal_message = {
      id: SecureRandom.uuid,
      sender_id: "sc_#{@session}",
      session: @session,
      sent_at: Time.now.to_i,
      text: data['message'],
      provider: 'sc'
    }
    @queue.publish(YAML.dump(internal_message))
  end

  private

  def render_message(message)
    ApplicationController.render(
      partial: 'messages/message',
      locals: {
        user_message: message,
        pb_message: ''
      }
    )
  end
end
