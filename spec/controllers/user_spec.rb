require 'rails_helper'

# При тестировании контроллеров необходимо проверить корректность работы вызываемых методов и формируемых ими запросов requests и ответов responses,
# а также проверить маршруты на предмет соответствия им тестируемому контроллеру, его действиям и передаваемым параметрам

RSpec.describe UsersController, type: :request do
  
  describe "GET #index" do

    # Используем хук before, чтобы перед каждым примером сформировать запрос GET к users#index
    before(:example) {get users_path} #get(:index)

    # проверяем, что метод index возвращает всех созданных пользователей
    it "assigns all users to @users" do
      expect(assigns(:users)).to eq(User.all)
    end

    # проверяем, что HTTP код запроса равен 200, что все хорошо
    it "has a 200 status code" do
      expect(response.status).to eq(200)
      #или по другому
      expect(response).to have_http_status(:ok)
    end

    # следующий мэтчер используется, чтобы удостовериться, что запрос отображает указанный шаблон (или макет)
    it "renders 'index' template" do
      expect(response).to render_template('index')
    end
  end

  describe "GET #new" do

    # Используем хук before, чтобы перед каждым примером сформировать запрос GET к users#new
    before(:example) {get new_user_path} #get :new

    # Тест проверяет, что возвращаемое запросом значение соответствует классу User 
    it "assigns @users" do
      expect(assigns(:user)).to be_instance_of(User)
    end

    # тест проверяет, что запрос отображает указанный шаблон
    it "renders the :new view" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do

    # набор тестов, помещенных в контекст success отвечает за правильную обработку запросов POST 
    context "success" do

      it "adds new user" do
        post users_path, params: { user: {id: 1, login: "username"}}  # формирование запроса POST с указанными параметрами
        #expect(User.last.login).to eq("username")                    # проверка, что в последней записи (которая была только что добавлена), один из аттрибутов имеет заданное в параметрах запроса значение
      end
    end

    # набор тестов, помещенных в контекст failure описывает поведение, когда новая запись не была создана 
    context "failure" do
      it "redirects to new when create fails" do
        User.delete_all                                         # очистка базы данных, если в ней вдруг что-то было
        post users_path, params: { user: {id: nil, login: nil}} # создание запроса с невалидными параметрами
        expect(response).to render_template(:new)               # проверка, что при обработке этого запроса контроллер рендерит представление для создания нового экземпляра User
        expect(User.count).to eq(0)                             # проверка, что в базу данных ничего не добавилось
      end
    end
  end

  describe "PUT #update" do
    # Используя FactoryGirl создаем тестовые данные, после этого формируется запрос PUT, обновляющий их
    before(:each) do
      @user = FactoryGirl.create(:user)                                       # создание тестовых данных с помощью FactoryGirl
      put userupdate_path, params: {user: {id: 1, login: "testlogin"}, id: 1} # создание запроса PUT
      @user.reload                                                            # обновление данных в базе данных путем перезагрузки
    end
    after(:each) do
      @user.destroy                                                           # уничтожение данных, чтобы иметь уверенность, что они удалились и не будут мешать другим примерам
    end
    it {expect(response).to redirect_to(@user)}                               # проверка, что после обработки запроса PUT происходит редирект 
    it {expect(@user.login).to eql "testlogin"}                               # проверка, что логин пользователя обновился
  end

  describe "DELETE #destroy" do
    # Используя FactoryGirl создаем тестовые данные, после этого формируется запрос DELETE, удаляющий их
    before(:each) do
      @user = FactoryGirl.create(:user)             # создание тестовых данных с помощью FactoryGirl
      delete "/users/1"                             # создание запроса DELETE
    end
    after(:each) do
      @user.destroy                                 # уничтожение данных, чтобы иметь уверенность, что они удалились и не будут мешать другим примерам
    end
    it {expect(response).to redirect_to(users_url)} # проверка, что после обработки запроса DELETE происходит редирект 
    it {expect(User.count).to eq(0)}                # проверка, что в результате обработки запроса DELETE удаляется указанная запись 
  end

  describe "testing private methods" do
    # RSpec позволяет также тестировать приватные методы
    it "should test set_user" do
      FactoryGirl.create(:user)                     # создание тестовых данных с помощью FactoryGirl
      # Так как контроллер в ходе выполнения не знает, что такое params, создается заглушка, замещающая ее
      allow_any_instance_of(UsersController).to receive(:params).and_return({id: 1})
      @test1 = UsersController.new.send(:set_user)  # вызов тестируемой функции
      expect(@test1.login).to eql "Login"           # проверка корректности возвращаемого объекта
    end
  end

  # Тестирование маршрутов на пример соответствия им тестируемому контроллеру, его действиям и передаваемым параметрам
  describe "Routes", type: :routing do
    it {should route(:get, '/users').to(action: :index)}
    it {should route(:get, '/users/1').to(action: :show, id: 1)}
    it {should route(:get, '/users/new').to(action: :new)}
    it {should route(:get, '/users/1/edit').to(action: :edit, id: 1)}
    it {should route(:post, '/users').to(action: :create)}
    it {should route(:put, '/users/1').to(action: :update, id: 1)}
    it {should route(:delete, '/users/1').to(action: :destroy, id: 1)}
  end
end