class Message < ApplicationRecord
  # Класс, описывающий таблицу с сообщениями в базе данных
  belongs_to :user
  belongs_to :chat
  mount_uploader :file, FileUploader
end
