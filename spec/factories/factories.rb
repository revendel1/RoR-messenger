FactoryGirl.define do
    factory :user do
        id 1
        login 'Login'
        password_digest 'password'
    end
    
    factory :chat do
        id 1
        name 'Chat 1'
        userlist [1,2]
        useradd nil
    end

    factory :message do
        id 1
        content 'message from factory'
        user_id 1
        chat_id 1
    end
end