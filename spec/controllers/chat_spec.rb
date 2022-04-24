require 'rails_helper'

# При тестировании контроллеров необходимо проверить корректность работы вызываемых методов и формируемых ими запросов requests и ответов responses,
# а также проверить маршруты на предмет соответствия им тестируемому контроллеру, его действиям и передаваемым параметрам

RSpec.describe ChatsController, type: :request do
  
  # Для аутентификации пользователя в приложении используется метод current_user, который хранит данные об авторизовавшемся пользователе
  # Чтобы повысить независимость тестов и ввиду того, что используемый метод может быть не реализован еще или просто недоступен, используется заглушка, заменяющая информацию, предоставляемую методом current_user
  # В локальную переменную signed_in_user записывается экземпляр класса User, полученный с использованием FactoryGirl
  # Далее реализуется заглушка, которая позволяет любому экземпляру класса ChatsController получать значение переменной signed_in_user при вызове current_user
  let(:signed_in_user) {FactoryGirl.create(:user)}
  before do
    allow_any_instance_of(ChatsController).to receive(:current_user).and_return(signed_in_user)
  end

  describe "GET #index" do

    # Используем хук before, чтобы перед каждым примером сформировать запрос GET к chats#index
    before(:example) {get chats_path} #get(:index)

    # проверка, что метод index возвращает все созданные чаты
    it "assigns all chats to @chats" do
      expect(assigns(:chats)).to eq(Chat.all)
    end

    # проверка, что HTTP код запроса равен 200, что все хорошо
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

    # Используем хук before, чтобы перед каждым примером сформировать запрос GET к chats#new
    before(:example) {get new_chat_path} #get :new

    # Тест проверяет, что возвращаемое запросом значение соответствует классу Chat 
    it "assigns @chats" do
      expect(assigns(:chat)).to be_instance_of(Chat)
    end

    # тест проверяет, что запрос отображает указанный шаблон
    it "renders the :new view" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET #show" do
    
    # С помощью FactoryGirl создаем экземпляр класса Chat и сформировать запрос GET к chats#show
    before(:example) do
      FactoryGirl.create(:chat)       # создание тестовых данных с помощью FactoryGirl
      get "/chats/1", params: {id: 1} # формирование запроса GET
    end

    # Использование различных мэтчеров, чтобы удостовериться в правильности работы метода
    it {expect(assigns(:chats)).to eq(Chat.all)}
    it {expect(assigns(:chat).userlist).to be_instance_of(Array)}
    it {expect(response.status).to eq(200)}
    it {expect(response).to render_template('index')}
  end

  describe "GET #edit" do

    # С помощью FactoryGirl создаем экземпляр класса Chat и сформировать запрос GET к chats#edit
    before(:example) do
      FactoryGirl.create(:chat) # создание тестовых данных с помощью FactoryGirl
      get "/chats/1/edit"       # формирование запроса GET
    end
    it {expect(assigns(:chats)).to eq(Chat.all)}
    it {expect(assigns(:chat).useradd).to be_instance_of(NilClass)}
    it {expect(response.status).to eq(200)}
  end

  describe "POST #create" do

    # набор тестов, помещенных в контекст success отвечает за правильную обработку запросов POST 
    context "success" do

      it "adds new chat" do
        Chat.delete_all                                           # очистка базу данных Chat (если этого не сделать, то в базе данных изначально будут лежать тестовые данные из fixtures)
        post chats_path, params: { chat: {id: 1, name: "chat1"}}  # формирование запроса POST с указанными параметрами
        expect(Chat.count).to eq(1)                               # проверка, что в базу данных добавилась запись
        expect(Chat.last.name).to eq("chat1")                     # проверка, что в последней записи (которую была только что добавлена), один из аттрибутов имеет заданное в параметрах запроса значение
      end

      it "redirects after create" do
        post chats_path, params: { chat: {id: 1, name: "chat1"}}  # формирование запроса POST с указанными параметрами
        expect(response.status).to be(302)                        # проверка, что HTTP код запроса равен 302 (Перемещено временно)
        expect(response.location).to match(/\/chats\/\d+/)        # проверка с помощью регулярного выражения, что ответ имеет location вида chats/d, где d это идентификатор созданной записи
      end
    end

    # набор тестов, помещенных в контекст failure описывает поведение, когда новая запись не была создана 
    context "failure" do
      it "redirects to new when create fails" do
        Chat.delete_all                                         # очистка базы данных, если в ней вдруг что-то было
        post chats_path, params: { chat: {id: nil, name: nil}}  # создание запроса с невалидными параметрами
        expect(response).to render_template(:new)               # проверка, что при обработке этого запроса контроллер рендерит представление для создания нового экземпляра Chat 
        expect(Chat.count).to eq(0)                             # проверка, что в базу данных ничего не добавилось 
      end
    end
  end

  describe "PUT #update" do
    # Используя FactoryGirl создаем тестовые данные, после этого формируется запрос PUT, обновляющий их
    before(:each) do
      @chat = FactoryGirl.create(:chat)                   # содание тестовых данных с помощью FactoryGirl
      put chatupdate_path, params: {id: 1, useradd: "3"}  # создание запроса PUT
      @chat.reload                                        # обновление данных в базе данных путем перезагрузки
    end
    after(:each) do
      @chat.destroy                                       # уничтожение данных, чтобы иметь уверенность, что они удалились и не будут мешать другим примерам
    end
    it {expect(response).to redirect_to(@chat)}           # проверка, что после обработки запроса PUT происходит редирект 
    it {expect(@chat.userlist).to eql [1,2,3]}            # проверка, что в список userlist добавилось переданное значение useradd
  end

  describe "DELETE #destroy" do
    # Используя FactoryGirl создаем тестовые данные, после этого формируется запрос DELETE, удаляющий их
    before(:each) do
      @chat = FactoryGirl.create(:chat) # создание тестовых данных с помощью FactoryGirl
      delete "/chats/1"                 # создание запроса  DELETE
      @chat.reload                      # обновление данных в базе данных путем перезагрузки
    end
    after(:each) do
      @chat.destroy                     # уничтожение данных, чтобы иметь уверенность, что они удалились и не будут мешать другим примерам
    end
    it {expect(response).to redirect_to(chats_url)} # проверка, что после обработки запроса DELETE происходит редирект 
    it {expect(@chat.userlist).to eql [2]}          # проверка, что в результате обработки запроса DELETE из массива userlist удаляется идентификатор, указанный в параметрах запроса
  end

  describe "testing private methods" do
    # RSpec позволяет также тестировать приватные методы
    it "should test set_chat" do
      FactoryGirl.create(:chat)                     # создание тестовых данных
      # Так как контроллер в ходе выполнения не знает, что такое params, создается заглушка, замещающая ее
      allow_any_instance_of(ChatsController).to receive(:params).and_return({id: 1})
      @test1 = ChatsController.new.send(:set_chat)  # вызов тестируемой функции
      expect(@test1.name).to eql "Chat 1"           # проверка корректности возвращаемого объекта
    end
  end

  # Тестирование маршрутов на пример соответствия им тестируемому контроллеру, его действиям и передаваемым параметрам
  describe "Routes", type: :routing do
    it {should route(:get, '/chats').to(action: :index)}
    it {should route(:get, '/chats/1').to(action: :show, id: 1)}
    it {should route(:get, '/chats/new').to(action: :new)}
    it {should route(:get, '/chats/1/edit').to(action: :edit, id: 1)}
    it {should route(:post, '/chats').to(action: :create)}
    it {should route(:put, '/chats/1').to(action: :update, id: 1)}
    it {should route(:delete, '/chats/1').to(action: :destroy, id: 1)}
  end
end
