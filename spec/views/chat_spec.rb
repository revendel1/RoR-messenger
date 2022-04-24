require 'rails_helper'

# При тестировании представлений целесообразно проверить наличие на отображаемой странице нужного контента, а также реакцию на нажатие различных кнопок и ссылок на странице
# Для тестирования представлений используются RSpec и Capybara

RSpec.describe "Creating a chat", type: :feature, :testview => true do
    
    let(:signed_in_user) {FactoryGirl.create(:user)}
    before do
        allow_any_instance_of(ChatsController).to receive(:current_user).and_return(signed_in_user)
    end

    scenario "needed page content" do
        visit new_chat_url                              # переход к тестируемому представлению
        expect(page).to have_text("Создать новый чат")  # проверка, что отобразилась форма для созданияя нового чата
        expect(page).to have_field("Название")
        expect(page).to have_text("Создать")
        expect(page).to have_button("Создать")
    end

    scenario "invalid inputs (name is blank)" do
        visit new_chat_url                                                          # переход к тестируемому представлению
        fill_in "Название", with: ''                                                # заполнение полей
        click_on "Создать"
        expect(page).to have_content("Name can't be blank")                         # выдача ошибки о пустом имени
        expect(page).to have_content("Name is too short (minimum is 1 character)")  # выдача ошибки о коротком имени
    end

    scenario "valid inputs" do
        visit new_chat_url                              # переход к тестируемому представлению
        fill_in "Название", with: 'Chat 1 test'         # заполнение полей
        Chat.delete_all                                 # очистка базы данных с чатами, так как в данный момент в ней находятся fixtures
        click_on "Создать"                              # нажатие кнопки для создания чата
        expect(Chat.count).to eq(1)                     # проверка что форма отработала верно и добавила новый чат
        expect(Chat.last.name).to eq "Chat 1 test"      # проверка, что добавились данные, которые были введены
    end
end

RSpec.describe "Editing a chat", type: :feature, :testview => true do
    
    let(:signed_in_user) {FactoryGirl.create(:user)}
    before do
        allow_any_instance_of(ChatsController).to receive(:current_user).and_return(signed_in_user)
    end

    scenario "needed page content" do
        visit edit_chat_url(id: 10)                                     # переход к тестируемому представлению
        expect(page).to have_title("Messenger")                         # проверка что открывшееся окно имеет нужный контент
        expect(page).to have_text("Добавление пользователя в чат")
        expect(page).to have_text("Выберите пользователя из списка:")
        expect(page).to have_select("useradd")
        expect(page).to have_button("Добавить")
        expect(page).to have_text("Вернуться назад")
        expect(page).to have_link("Вернуться назад")
    end

    scenario "valid inputs" do
        allow_any_instance_of(ChatsController).to receive(:params).and_return({id:20, useradd: 1})
        visit edit_chat_url(id: 20)                 # переход к тестируемому представлению
        expect(Chat.last.userlist).to eq [2,3]      # проверка, что последняя запись имеет поле с ожидаемом значением
        click_on "Добавить"                         # нажатие кнопки Добавить
        expect(Chat.last.userlist).to eq [2,3,1]    # проверка, что в нужное поле последней записи добавилось заданное значение
    end

    scenario 'link chats_path works' do
        visit edit_chat_url(id: 10)                 # переход к тестируемому представлению
        click_link "Вернуться назад"                # переход обратно на главную страницу
        expect(page).to have_text("Ваш никнейм:")   # проверка отображения главной страницы
    end
end

RSpec.describe "View chats", type: :feature, :testview => true do

    let(:signed_in_user) {FactoryGirl.create(:user)}
    before do
        allow_any_instance_of(ChatsController).to receive(:current_user).and_return(signed_in_user)
    end

    scenario "needed page content" do
        visit root_url                                  # переход к тестируемому представлению
        expect(page).to have_title("Messenger")         # проверка что страница имеет необходимый контент
        expect(page).to have_text("Ваш никнейм:")
        expect(page).to have_text("Выйти")
        expect(page).to have_text("Создать новый чат")
        expect(page).to have_link("Выйти")
        expect(page).to have_link("✖")
    end

    scenario 'link logout works' do
        visit root_url                          # переход к тестируемому представлению
        click_link "Выйти"                      # переход обратно на главную страницу
        expect(page).to have_title('Messenger') # проверка, что отобразилась нужная страница
    end

    scenario 'link logout works' do
        visit root_url                          # переход к тестируемому представлению
        expect(Chat.first.userlist).to eq [1,2] # проверка что первая запись имеет поле с ожидаемым значением
        click_link "✖"                          # нажатие кнопки для удаления из чата пользователя
        expect(Chat.first.userlist).to eq [2]   # проверка, что из поля первой записи удалилось заданное значение
    end
end