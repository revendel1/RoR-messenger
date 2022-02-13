require 'test_helper'

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat = chats(:one)
  end

  test "should get index" do
    get chats_url
    assert_response :success
  end

  #test "should create chat" do
    #assert_difference('Chat.count') do
      #post chats_url, params: { chat: { name: @chat.name } }
    #end
    #assert_redirected_to chat_url(Chat.last)
  #end

  test "should show chat" do
    get chat_url(@chat)
    assert_response :success
  end

  test "should update chat" do
    patch chat_url(@chat), params: { chat: { name: @chat.name } }
    assert_redirected_to chat_url(@chat)
  end

end