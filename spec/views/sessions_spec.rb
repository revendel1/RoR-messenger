require 'rails_helper'

# При тестировании представлений целесообразно проверить наличие на отображаемой странице нужного контента, а также реакцию на нажатие различных кнопок и ссылок на странице
# Для тестирования представлений используются RSpec и Capybara

RSpec.describe "Log In into the app", type: :feature, :testview => true do
    
    before do
        FactoryGirl.create(:user)
    end
    scenario "needed page content" do
        visit login_path                                    # переход к тестируемому представлению
        expect(page).to have_button('Войти')                # проверка имеется ли на странице необходимая кнопка
        expect(page).to have_title("Messenger")             # проверка имеет ли страница необходимый заголовок
        expect(page).to have_text("Логин")                  # проверка имеется ли на странице необходимый текст
        expect(page).to have_text("Пароль")
        expect(page).to have_text("Войти")
        expect(page).to have_text("Зарегистрироваться")
        expect(page).to have_link("Зарегистрироваться")     # проверка имеется ли на странице необходимая ссылка
        expect(page).to have_text("На главную страницу")
        expect(page).to have_link("На главную страницу")
        expect(page).to have_field(:login)                  # проверка имеется ли на странице необходимое поле
        expect(page).to have_field(:password)
        page.has_css?('card-title mb-3', text: 'Войти')     # возможность проверки имеется ли на странице нужный стиль CSS
    end

    scenario 'invalid login in inputs' do
        visit login_path                                                # переход к тестируемому представлению
        fill_in :login, with: ""                                        # заполнение полей
        fill_in :password, with: "password"
        click_on 'Войти'                                                # нажатие кнопки входа
        expect(page).to have_text("Username or password is invalid")    # страница выводит информацию, что введенные данные невалидны
    end

    scenario 'invalid password in inputs' do
        visit login_path                                                # переход к тестируемому представлению
        fill_in :login, with: "username"                                # заполнение полей
        fill_in :password, with: ""
        click_on 'Войти'                                                # нажатие кнопки входа
        expect(page).to have_text("Username or password is invalid")    # страница выводит информацию, что введенные данные невалидны
    end

    scenario 'link sign_up works' do
        visit login_path                                # переход по ссылке к окну регистрации
        click_on 'Зарегистрироваться'                   # нажатие кнопки для регистрации                
        expect(page).to have_text('Зарегистрироваться') # проверка, что отобразилось окно регистрации
        expect(page).to have_text('Логин')
        expect(page).to have_text('Пароль')
        expect(page).to have_text('Подтвердите пароль')
    end

    scenario 'link root_url works' do
        visit login_path                                # переход по ссылке к окну регистрации
        click_on 'На главную страницу'                  # переход на главную страницу
        expect(page).to have_text('Мессенджер')         # проверка отображения главной страницы
        expect(page).to have_text('Добро пожаловать')
    end
end