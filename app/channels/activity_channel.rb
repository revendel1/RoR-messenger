class ActivityChannel < ApplicationCable::Channel
  def subscribed
    stream_from "activity_channel"
  end
  
  def appear
    # Когда пользователь входит в приложение, ему выдается статус онлайн
    ActionCable.server.broadcast "activity_channel", user_id: current_user.id, status: 'online'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # Когда пользователь выходит из приложения ему выдается статус оффлайн
    ActionCable.server.broadcast "activity_channel", user_id: current_user.id, status: 'offline'
  end

end
