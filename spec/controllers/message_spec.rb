require 'rails_helper'

# При тестировании контроллеров необходимо проверить корректность работы вызываемых методов и формируемых ими запросов requests и ответов responses,
# а также проверить маршруты на предмет соответствия им тестируемому контроллеру, его действиям и передаваемым параметрам

RSpec.describe MessagesController, type: :request do
  
  # Для аутентификации пользователя в приложении используется метод current_user, который хранит данные об авторизовавшемся пользователе
  # Чтобы повысить независимость тестов и ввиду того, что используемый метод может быть не реализован еще или просто недоступен, используется заглушка, заменяющая информацию, предоставляемую методом current_user
  # В локальную переменную signed_in_user записывается экземпляр класса User, полученный с использованием FactoryGirl
  # Далее реализуется заглушка, которая позволяет любому экземпляру класса ChatsController получать значение переменной signed_in_user при вызове current_user
  let(:signed_in_user) {FactoryGirl.create(:user)}
  before do
    FactoryGirl.create(:chat)
    allow_any_instance_of(MessagesController).to receive(:current_user).and_return(signed_in_user)
  end

  describe "GET #index" do

    # Используем хук before, чтобы перед каждым примером сформировать запрос GET к messages#index
    before(:example) {get messages_path} #get(:index)

    # проверка, что метод index возвращает все созданные сообщения
    it "assigns all messages to @messages" do
      expect(assigns(:messages)).to eq(Message.all)
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

  describe "POST #create" do

    # набор тестов, помещенных в контекст success отвечает за правильную обработку запросов POST 
    context "success" do

      it "adds new message" do
        post messages_path, params: { message: {id: 1, content: "messge1", user_id: 1, chat_id: 1}}   # формирование запроса POST с указанными параметрами
        expect(Message.count).to eq(1)                                                                # проверка, что в базу данных добавилась запись
        expect(Message.last.content).to eq("messge1")                                                 # проверка, что в последней записи (которая была только что добавлена), один из аттрибутов имеет заданное в параметрах запроса значение
      end

      it "redirects after create" do
        post messages_path, params: { message: {id: 1, content: "message2", user_id: 1, chat_id: 1}}  # формирование запроса POST с указанными параметрами
        expect(response.status).to be(302)                                                            # проверка, что HTTP код запроса равен 302 (Перемещено временно)
      end
    end
  end

  describe "PUT #update" do
    # Используя FactoryGirl создаем тестовые данные, после этого формируется запрос PUT, обновляющий их
    before(:each) do
      @message = FactoryGirl.create(:message)                                                                         # создание тестовых данных с помощью FactoryGirl
      put messageupdate_path, params: { message: {id: 1, content: "updated message", user_id: 1, chat_id: 1}, id: 1}  # формирование запроса PUT
      @message.reload                                                                                                 # обновление данных в базе данных путем перезагрузки
    end
    after(:each) do
      @message.destroy                                                                                                # уничтожение данных, чтобы иметь уверенность, что они удалились и не будут мешать другим примерам
    end
    it {expect(response).to redirect_to(@message)}          # проверка, что после обработки запроса PUT происходит редирект 
    it {expect(@message.content).to eql "updated message"}  # проверка, что в список userlist добавилось переданное значение useradd
  end

  describe "DELETE #destroy" do
    # Используя FactoryGirl создаем тестовые данные, после этого формируется запрос DELETE, удаляющий их
    before(:each) do
      @message = FactoryGirl.create(:message) # создание тестовых данных с помощью FactoryGirl
      delete "/messages/1"                    # формирование запроса DELETE
    end
    after(:each) do
      @message.destroy                        # уничтожение данных, чтобы иметь уверенность, что они удалились и не будут мешать другим примерам
    end
    it {expect(response).to redirect_to(messages_url)}  # проверка, что после обработки запроса DELETE происходит редирект 
    it {expect(Message.count).to eq(0)}                 # проверка, что в результате обработки запроса DELETE удаляется запись
  end

  describe "testing private methods" do
    # RSpec позволяет также тестировать приватные методы
    it "should test set_message" do
      FactoryGirl.create(:message) # создание тестовых данных
      # Так как контроллер в ходе выполнения не знает, что такое params, создается заглушка, замещающая ее
      allow_any_instance_of(MessagesController).to receive(:params).and_return({id: 1})
      @test1 = MessagesController.new.send(:set_message)    # вызов тестируемой функции
      expect(@test1.content).to eql "message from factory"  # проверка корректности возвращаемого объекта
    end
  end

  # Тестирование маршрутов на пример соответствия им тестируемому контроллеру, его действиям и передаваемым параметрам
  describe "Routes", type: :routing do
    it {should route(:get, '/messages').to(action: :index)}
    it {should route(:get, '/messages/1').to(action: :show, id: 1)}
    it {should route(:get, '/messages/new').to(action: :new)}
    it {should route(:get, '/messages/1/edit').to(action: :edit, id: 1)}
    it {should route(:post, '/messages').to(action: :create)}
    it {should route(:put, '/messages/1').to(action: :update, id: 1)}
    it {should route(:delete, '/messages/1').to(action: :destroy, id: 1)}
  end
end