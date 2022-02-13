class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]

  # GET /chats
  # GET /chats.json
  def index
    @chats = Chat.all
  end

  # GET /chats/1
  # GET /chats/1.json
  def show
    @chats = Chat.all
    render 'index'
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
    @chats = Chat.all
  end

  # POST /chats
  # POST /chats.json
  def create
    @chat = Chat.new(chat_params)
    @chat.userlist.push(current_user.id)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to @chat, notice: 'Chat was successfully created.' }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1
  # PATCH/PUT /chats/1.json
  def update
    # добавление id пользователя в массив пользователей, кому доступен данный чат
    @room = Chat.find_by_id(@chat.id)
      if (params[:useradd].to_i != 0) then
        @room.userlist.push(params[:useradd].to_i)
      end
      @room.save
    respond_to do |format| 
      format.html { redirect_to @chat, notice: 'Chat was successfully updated.' }
      format.json { render :show, status: :ok, location: @chat }
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.json
  def destroy
    # удаляет пользователя из массива пользователей, имеющих доступ к чату.
    @chat.userlist.delete(current_user.id)
    if @chat.userlist.size() ==  0 then
      #@chat.destroy
    end
    @chat.save 
    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Chat was successfully updated.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:name, :useradd, {userlist: []})
    end
end
