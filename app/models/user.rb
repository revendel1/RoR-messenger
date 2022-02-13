class User < ApplicationRecord
    # Класс, описывающий таблицу с пользователями в базе данных
    has_many :messages
    has_secure_password
    validates :login, presence: true, uniqueness: true
end
