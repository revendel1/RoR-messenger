require 'rails_helper'

RSpec.describe SendMessageJob, type: :job do
  describe "#perform_later" do
    it "send message" do
      @message = Message.new(id: 1, content: "Message 1", user_id: 1, chat_id: 1, created_at: DateTime.now, updated_at: DateTime.now, file: "")
      ActiveJob::Base.queue_adapter = :test   # необходимо установить для использования мэтчеров ActionJob

      #проверка, что очередь пустая
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 0
      
      #проверка, что job было поставлено в очередь
      expect{SendMessageJob.perform_later(@message)}.to have_enqueued_job

      #проверка, что очередь не пустая
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 1
    end
  end
end
