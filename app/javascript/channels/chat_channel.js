import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const chat_element = document.getElementById('chat-id');
  const chat_id = chat_element.getAttribute('data-chat-id');

  //window.subscriptions = consumer.subscriptions
  //console.log(consumer.subscriptions)

  consumer.subscriptions.subscriptions.forEach((subscription) => {
    if (JSON.parse(subscription.identifier).channel == 'ChatChannel') 
      consumer.subscriptions.remove(subscription)
  })
  
  consumer.subscriptions.create({ channel: "ChatChannel", chat_id: chat_id }, {
    connected() {
      console.log("connected to chat channel " + chat_id)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      //разделяет сообщения пользователей на сообщения от данного пользователя для
      //отображения их в правой части экрана от сообщений других пользователей
      const user_element = document.getElementById('user-id');
      const user_id = Number(user_element.getAttribute('data-user-id'));

      let html;

      if (user_id === data.message.user_id) {
        html = data.mine
      } else {
        html = data.theirs
      }
      
      const messageContainer = document.getElementById('messages')
      messageContainer.innerHTML = messageContainer.innerHTML + html
    }
  });
})