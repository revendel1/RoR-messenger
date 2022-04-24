require 'rails_helper'

RSpec.describe ActivityChannel, type: :channel do

    it "subscribes successfully" do
        subscribe
        expect(subscription).to be_confirmed
    end

    it "subscribes also successfully" do
        stub_connection user_id: 10
        subscribe
        expect(subscription).to be_confirmed
        expect(subscription.user_id).to eq 10
    end

    it "subscribes to activity channel" do
        subscribe
        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_from("activity_channel")
    end
end
