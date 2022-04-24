require 'rails_helper'

# При тестировании контроллеров необходимо проверить корректность работы вызываемых методов и формируемых ими запросов requests и ответов responses,
# а также проверить маршруты на предмет соответствия им тестируемому контроллеру, его действиям и передаваемым параметрам

RSpec.describe SessionsController, type: :request do
    
  # Для аутентификации пользователя в приложении используется метод current_user, который хранит данные об авторизовавшемся пользователе
  # Чтобы повысить независимость тестов и ввиду того, что используемый метод может быть не реализован еще или просто недоступен, используется заглушка, заменяющая информацию, предоставляемую методом current_user
  # В локальную переменную signed_in_user записывается экземпляр класса User, полученный с использованием FactoryGirl
  # Далее реализуется заглушка, которая позволяет любому экземпляру класса ChatsController получать значение переменной signed_in_user при вызове current_user
  let(:signed_in_user) {{user: {id: 2, login: 'Login2', password: "password"}}}
  before do
    allow_any_instance_of(SessionsController).to receive(:current_user).and_return(signed_in_user)
  end

  describe "POST #create" do
    
    before(:each) do
        FactoryGirl.create(:user) # создание тестовых данных с помощью FactoryGirl
    end

    # набор тестов, помещенных в контекст success отвечает за правильную обработку запросов POST 
    context "success" do
    
      it "adds new session" do
        post sessions_path, params: {login: 'Login3', password: "password", chat: {id:1, name: "Chat 1", userlist: [1,2]}}  # формирование запроса POST с указанными параметрами
        expect(session.empty?).to eq(false)                                                                                 # массив sessions, являющийся экземпляром класса ActionDispatch::Request::Sessions, не является пустым
      end
    end

    # набор тестов, помещенных в контекст failure описывает поведение, когда новая запись не была создана 
    context "failure" do
      it "redirects to new when create fails" do
        post sessions_path, params: {login: 'Login3', password: "password", chat: {id:1, name: "Chat 1", userlist: [1,2]}}  # формирование запроса POST с указанными параметрами
        expect(response).to render_template(:new)                                                                           # ожидание отображения шаблона new в результате запроса
      end
    end
  end

  describe "DELETE #destroy" do

    before(:each) do
      FactoryGirl.create(:user) # создание тестовых данных с помощью FactoryGirl
    end

    it "should create and destroy session" do
      post sessions_path, params: {login: 'Login3', password: "password", chat: {id:1, name: "Chat 1", userlist: [1,2]}}  # формирование запроса POST с указанными параметрами, создающий новую сессию
      delete logout_path                                                                                                  # удаление сессии запросом DELETЕ
    end
  end

  # Тестирование маршрутов на пример соответствия им тестируемому контроллеру, его действиям и передаваемым параметрам
  describe "Routes", type: :routing do
    it {should route(:delete, logout_path).to(action: :destroy)}
    it {should route(:post, '/sessions').to(action: :create)}
  end
end