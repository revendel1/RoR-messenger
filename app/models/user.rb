class User < ApplicationRecord
    # Класс, описывающий таблицу с пользователями в базе данных
    has_many :messages
    has_secure_password
    validates :login, length:{minimum:1, maximum:100}, presence: true, uniqueness: true, allow_blank: false
end
