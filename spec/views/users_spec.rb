require 'rails_helper'

# При тестировании представлений целесообразно проверить наличие на отображаемой странице нужного контента, а также реакцию на нажатие различных кнопок и ссылок на странице
# Для тестирования представлений используются RSpec и Capybara

RSpec.describe "Creating a user", type: :feature, :testview => true do
    
    scenario "needed page content" do
        visit signup_url                                    # переход к тестируемому представлению
        expect(page).to have_title("Messenger")             # проверка наличия на странице необходимого контента
        expect(page).to have_text("Логин")
        expect(page).to have_field("Логин")
        expect(page).to have_text("Пароль")
        expect(page).to have_field("Пароль")
        expect(page).to have_text("Подтвердите пароль")
        expect(page).to have_field("Подтвердите пароль")
        expect(page).to have_text("Зарегистрироваться")
        expect(page).to have_button("Зарегистрироваться")
        expect(page).to have_text("На главную страницу")
        expect(page).to have_link("На главную страницу")
    end

    # проверка контента страницы с использованием однострочных мэтчеров
    describe "using one-line matchers" do
        before {visit signup_url}
        it {expect(page).to have_title("Messenger")}
        it {expect(page).to have_text("Логин")}
        it {expect(page).to have_field("Логин")}
        it {expect(page).to have_field("Пароль")}
        it {expect(page).to have_button("Зарегистрироваться")}
        it {expect(page).to have_link("На главную страницу")}
    end

    scenario "invalid inputs (login is blank)" do
        visit signup_url                                        # переход к тестируемому представлению
        fill_in "Логин", with: ''                               # заполнение полей
        fill_in "Пароль", with: 'password'
        fill_in "Подтвердите пароль", with: 'password'
        click_on "Зарегистрироваться"                           # нажатие кнопки
        expect(page).to have_content("Login can't be blank")    # проверка о выдаче сообщения, что значение пустое
        expect(page).to have_content("Login is too short")      # проверка о выдаче сообщения, что значение слишком короткое
    end

    scenario "invalid inputs (password confirmation doesn't match)" do
        visit signup_url                                                    # переход к тестируемому представлению
        fill_in "Логин", with: 'username'                                   # заполнение полей
        fill_in "Пароль", with: 'password1'
        fill_in "Подтвердите пароль", with: 'password'
        click_on "Зарегистрироваться"                                       # нажатие кнопки
        expect(page).to have_content("Password confirmation doesn't match") # проверка о выдаче сообщения, что значения паролей не совпадают
    end

    scenario "invalid inputs (password is blank)" do
        visit signup_url                                                    # переход к тестируемому представлению
        fill_in "Логин", with: 'username'                                   # заполнение полей
        fill_in "Пароль", with: ''
        fill_in "Подтвердите пароль", with: ''
        click_on "Зарегистрироваться"                                       # нажатие кнопки
        expect(page).to have_content("Password can't be blank")             # проверка о выдаче сообщения, что значения паролей не может быть пустым
    end

    scenario "valid input" do
        visit signup_url                                                    # переход к тестируемому представлению
        fill_in "Логин", with: 'username'                                   # ввод валидных логина и пароля
        fill_in "Пароль", with: 'password'                                 
        fill_in "Подтвердите пароль", with: 'password'
        click_on "Зарегистрироваться"                                       # нажатие кнопки регистрации
        expect(User.count).to eq(1)                                         # проверка что форма отработала верно и добавила нового пользователя
        expect(User.last.login).to eq "username"                            # проверка, что добавились данные, которые были введены
    end

    scenario 'link root_url works' do
        visit login_path                                                    # переход к тестируемому представлению
        click_on 'На главную страницу'                                      # переход на главную страницу
        expect(page).to have_text('Мессенджер')                             # проверка отображения главной страницы
        expect(page).to have_text('Добро пожаловать')
    end
    
end