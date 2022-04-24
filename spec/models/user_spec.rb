require 'rails_helper'

#При тестировании созданной модели необходимо проверить такие аспекты как: корректность аргументов созданной таблицы,
#её связи с другими таблицами, валидность добавляемых в таблицу записей

#ключевое слово describe служит для определения набора связанных тестов. Может принимать строку или, как в данном случае, класс в качестве аргумента
# "type: :model" - метаданные,подсказывающие, что мы тестируем модель

RSpec.describe User, type: :model do

  # В данном наборе тесте применяется гем Shoulda Matchers, предоставляющий однострочные мэтчеры.
  describe 'attributes' do
    #мэтчеры проверяют содержатся ли в таблице, поддерживающей модель, указанные столбцы заданного типа данных
    it {should have_db_column(:id).of_type(:integer)}
    it {should have_db_column(:login).of_type(:string)}
    it {should have_db_column(:password_digest).of_type(:string)}
    it {should have_db_column(:created_at)}
    it {should have_db_column(:updated_at)}
  end

  describe 'association' do
    # мэтчер have_many используется, чтобы установить, что в модели существуют ассоциации 'has_many'
    it {should have_many(:messages)}
  end

  describe 'validation' do

    # Factorygirl (или более новый FactoryBot), это гем, позволяющий создавать объекты, относящиеся ко встроенным тестам.
    # Является альтернативой fixtures, которые используются в ./spec/models/chat_spec.rb
    it "should have valid factory" do
      expect(FactoryGirl.build(:user)).to be_valid
    end

    it "should require a login" do
      expect(FactoryGirl.build(:user, :login => "")).not_to be_valid
    end

    it "should require a password" do
      expect(FactoryGirl.build(:user, :password_digest => "")).not_to be_valid
    end

    subject {
      FactoryGirl.build(:user)
    }

    # мэтчер have_secure_password проверяет используется ли макрос 'has_secure_password'
    it {should have_secure_password}

    # мэтчеры проверяют опции поля для логина в созданной таблице
    it {should validate_length_of(:login).is_at_least(1)}
    it {should validate_length_of(:login).is_at_most(100)}
    it {should validate_presence_of(:login)}
    it {should validate_uniqueness_of(:login)}
  end
end
