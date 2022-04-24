require 'rails_helper'

RSpec.describe ChatChannel, type: :channel do

  it "succesfully subscribes" do
    subscribe chat_id: 1
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("chat_channel_1")
  end

  it "rejects subscribtion" do
    subscribe chat_id: nil
    expect(subscription).to be_rejected
  end
end
