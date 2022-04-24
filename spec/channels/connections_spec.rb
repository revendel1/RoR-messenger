require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do

    before do
        FactoryGirl.create(:user)                   # необходимо что-то иметь в базе данных User, чтобы методу find_verified_user в channels/application_cable_connection.rb было из чего искать
    end

    it "successfully connects" do
        cookies[:user_id] = 1                       # указываем id = 1 и записываем его в cookies, чтобы методу find_verified_user было что искать
        connect "/cable"                            # создание соединения
        expect(connection.current_user.id).to eq 1  # проверка, что current_user.id равен заданному        
    end

    it "rejects connection" do
        expect{connect "/cable"}.to have_rejected_connection # проверка, что без заданного id пользователя метод find_verified_user "отвергает" (reject) соединение
    end
end