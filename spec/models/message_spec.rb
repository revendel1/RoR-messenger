require 'rails_helper'

#При тестировании созданной модели необходимо проверить такие аспекты как: корректность аргументов созданной таблицы,
#её связи с другими таблицами, валидность добавляемых в таблицу записей

#ключевое слово describe служит для определения набора связанных тестов. Может принимать строку или, как в данном случае, класс в качестве аргумента
# "type: :model" - метаданные,подсказывающие, что мы тестируем модель
RSpec.describe Message, type: :model do
  
  describe 'attributes' do

    %w[id
      content
      user_id
      chat_id 
      created_at 
      updated_at 
      file 
    ].each do |attribute|
        # метод it() определяет фактически тесты Rspec и принимает опциональную строку, которая определяет какое поведение мы тестируем. Метод используется с блоком, который описывает ожидаемый результат теста
        it "should have attribute" do
          @message1 = Message.new
          expect(@message1).to have_attribute(attribute) #проверкаимеется ли в таблице такой атрибут
        end
    end

    it "should be correct types" do
      @message1 = Message.new(id: 1, content: "Message 1", user_id: 1, chat_id: 1, created_at: DateTime.now, updated_at: DateTime.now, file: "")
      #мэтчер be_kind_of проверяет присутствует ли передаваемый объект в иерархии классов объекта, передаваемого в ожиданиях. Или модулем, включенным в один из классов этой иерархии
      expect(@message1.content).to be_a_kind_of(String)
      expect(@message1.user_id).to be_a_kind_of(Integer)
      expect(@message1.chat_id).to be_a_kind_of(Integer)
      expect(@message1.created_at).to be_a_kind_of(ActiveSupport::TimeWithZone) # Класс, предоставляющий методы для работы со временем, который добавляет ко времени еще и временной пояс. Многие методы с часовым поясом возвращают объекты именно этого класса.
      expect(@message1.updated_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
      expect(@message1.file).to be_a_kind_of(FileUploader)
    end
  end

  describe 'relationships' do
    # мэтчер belong_to используется, чтобы установить, что в модели существуют ассоциации 'belong_to'
    it {is_expected.to belong_to(:chat)}
    it {is_expected.to belong_to(:user)}
  end

  describe 'validations' do

    #методы before() и after() принимают значения :each и :all, которые определяют, выполняется ли нужный нам блок перед всеми тестами сразу или перед каждым по отдельности
    before(:each) do
      #в данном случае создаем просто новый экземпляр нашего класса
      @message = Message.new 
    end

    after(:each) do
      @message.destroy                  # уничтожение данных, чтобы иметь уверенность, что они удалились и не будут мешать другим примерам
    end

    it "should not be valid" do
      expect(@message).not_to be_valid  # ожидание, что пустой объект будет невалидным
    end

    it "should be valid" do
      # так как Message зависит от классов User и Chat, создадим экземпляры этих классов
      chat1 = Chat.create(id:1, name: "Chat 1")
      user1 = User.create(id:1, login: "Login1", password_digest: "qwerty")
      @message.id = 1
      @message.content = "Message 1"
      @message.user_id = user1.id
      @message.chat_id = chat1.id
      expect(@message).to be_valid
    end

    # передаем subject в тесты неявным образом, так как не указан получатель
    # метод validate_presence_of проверяет наличие значения атрибута :name 
    it {is_expected.to validate_presence_of(:user_id)}
    it {is_expected.to validate_presence_of(:chat_id)}

    # let это локальная переменная, возвращающая результат переданного блока, вычисляемого лениво
    let(:message_test) {Message.new}
    it "should require name" do
      expect(message_test).to_not be_valid
      expect(message_test.errors[:user_id]).not_to be_nil
    end
  end
end
