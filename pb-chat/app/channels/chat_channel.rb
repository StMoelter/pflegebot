# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'messages' # point to uniq channel
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # send to queue
    # activate message read and typing

    # Broadcast shall be called message from amqp queue
    ActionCable.server.broadcast('messages', message: render_message(data['message']))
  end


  private

  def render_message(message)
    ApplicationController.render(
        partial: 'messages/message',
        locals: {
            message: message,
            username: 'Fake User Name'
        })
  end

end
