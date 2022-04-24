require 'rails_helper'

#При тестировании созданной модели необходимо проверить такие аспекты как: корректность аргументов созданной таблицы,
#её связи с другими таблицами, валидность добавляемых в таблицу записей

#ключевое слово describe служит для определения набора связанных тестов. Может принимать строку или, как в данном случае, класс в качестве аргумента
# "type: :model" - метаданные,подсказывающие, что мы тестируем модель
RSpec.describe Chat, type: :model do    
  
  describe 'attributes' do

    %w[id
      name 
      created_at 
      updated_at 
      userlist 
      useradd 
    ].each do |attribute|
        # метод it() определяет фактически тесты Rspec и принимает опциональную строку, которая определяет какое поведение мы тестируем. Метод используется с блоком, который описывает ожидаемый результат теста
        it "should have attribute" do
          @chat1 = Chat.new
          expect(@chat1).to have_attribute(attribute) #проверка наличия такого атрибута
        end
    end

    it "should be correct types" do
      @chat1 = Chat.new(id: 1, name: "Chat 1", created_at: DateTime.now, updated_at: DateTime.now, userlist: [1, 2], useradd: "1")
      #мэтчер be_kind_of проверяет присутствует ли передаваемый объект в иерархии классов объекта, передаваемого в ожиданиях. Или модуль, включенный в один из классов этой иерархии
      expect(@chat1.name).to be_a_kind_of(String)
      expect(@chat1.created_at).to be_a_kind_of(ActiveSupport::TimeWithZone) # Класс, предоставляющий методы для работы со временем, который добавляет ко времени еще и временной пояс. Многие методы с часовым поясом возвращают объекты именно этого класса.
      expect(@chat1.updated_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
      expect(@chat1.userlist).to be_a_kind_of(Array)
      expect(@chat1.useradd).to be_a_kind_of(String)
    end

    # мэтчер serialize проверяет применение одноименного метода к объекту таблицы 
    # (в данном тесте применяется гем Shoulda Matchers, предоставляющий однострочные мэтчеры. Больше тестов с использованием этого гема в ./spec/models/user_spec.rb)
    it {is_expected.to serialize(:userlist)}
  end

  describe 'relationships' do
    # мэтчер have_many используется, чтобы установить, что в модели существуют ассоциации 'has_many' и 'has_many :through'
    it {is_expected.to have_many(:messages)}
    it {is_expected.to have_many(:users).through(:messages)}
  end

  describe 'validations' do

    #методы before() и after() принимают значения :each и :all, которые определяют, выполняется ли нужный нам блок перед всеми тестами сразу или перед каждым по отдельности
    before(:each) do
      #в данном случае создаем просто новый экземпляр нашего класса
      @chat = Chat.new 
    end

    after(:each) do
      @chat.destroy                   # уничтожение данных, чтобы иметь уверенность, что они удалились и не будут мешать другим примерам
    end

    it "should not be valid" do
      expect(@chat).not_to be_valid   # ожидание, что пустой объект будет невалидным
    end

    it "should be valid" do
      @chat.id = 1
      @chat.name = "Chat 1"
      @chat.created_at = DateTime.now
      @chat.updated_at = DateTime.now
      @chat.userlist = [1, 2]
      expect(@chat).to be_valid
    end

    # let это локальная переменная, возвращающая результат переданного блока, вычисляемого лениво
    let(:chat_test) {Chat.new}
    it "should require name" do
      expect(chat_test).to_not be_valid
      expect(chat_test.errors[:name]).not_to be_nil
    end

    # subject это особенный let, чья главная особенность заключается в том, что все матчеры, у которых не указан получатель, применяются к subject
    subject {
      Chat.new( id: 1,
              name: "Chat 1",
              created_at: DateTime.now,
              updated_at: DateTime.now,
              userlist: [1, 2])
    }
    
    # передаем subject в тест явным образом
    it "should be also valid" do
      expect(subject).to be_valid
    end

    # передаем subject в тесты неявным образом, так как не указан получатель
    # метод validate_presence_of проверяет наличие значения атрибута :name 
    it {is_expected.to validate_presence_of(:name)}

    # метод validate_length_of проверяет длину атрибута :name, являющегося строкой
    it {is_expected.to validate_length_of(:name).is_at_least(1)}
    it {is_expected.to validate_length_of(:name).is_at_most(100)}

    # RSpec позволяет также проверять на соответствие объекты в ожиданиях с регулярными выражениями, например.
    # (так как в тестируемой программе не предъявляется требований к названиям чатов, то поэтому данный тест закомментирован)
      #it "is not valid if chat name is not consist of letters or digits" do
      #  expect((subject.name).match?(/[a-zа-я0-9_ ]/i)).to eq(true)
      #end
  end

  describe "text with fixtures" do

=begin
      fixtures - набор данных, выступающие в качестве шаблона, предназначенных для тестов, которые мы можем интерактивно изменять. Хранятся в ./spec/fixtures/chat.yml
      Хранятся в виде списка пар ключ-значение, представленного столбцом.
      Используя их, можно просимулировать различные ассоциации в наших моделях.
      Однако для наборов данных, которые больше и сложнее, фикстуры сложно поддерживать, а также изменять их без влияния на другие тесты. Можно, однако, решить эту проблему, но это весьма затратно
      Поэтому, чтобы избежать повреждения тестовых данных при непредвиденных ошибках, создали новые стратегии, которые более динамичные и гибкие. Например, FactoryGirl, которая используется в ./spec/models/user_spec.rb
=end
    fixtures :chat

    it "clears chats" do
      # используя symbols можем обращаться к фикстурам напрямую
      chat(:one).destroy
      expect(lambda{chat(:one).reload}).to raise_error(ActiveRecord::RecordNotFound)  # ожидание, что при попытке обращения к удаленной записи возникнет ошибка
    end
    it "should be also valid" do
      # используя symbols можем обращаться к фикстурам напрямую
      expect(chat(:two)).to be_valid
      chat(:two).destroy
    end
  end
end
