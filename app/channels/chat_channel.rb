class ChatChannel < ApplicationCable::Channel
  def subscribed
    # Приложение отслеживает в какой из чатов зашел пользователь
    stream_from "chat_channel_#{params[:chat_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
