class Chat < ApplicationRecord
    # Класс, описывающий таблицу с чатами в базе данных
    has_many :messages
    has_many :users, through: :messages
    serialize :userlist, Array
    validates :name, length: {minimum: 1, maximum: 100}, presence: true, allow_blank: false
end
