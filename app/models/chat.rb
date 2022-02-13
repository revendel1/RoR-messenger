class Chat < ApplicationRecord
    # Класс, описывающий таблицу с чатами в базе данных
    has_many :messages
    has_many :users, through: :messages
    serialize :userlist, Array
end
