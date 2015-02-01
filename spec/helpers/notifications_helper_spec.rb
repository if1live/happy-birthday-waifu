require 'rails_helper'


describe NotificationsHelper do
  let(:dummy_class) { Class.new { include NotificationsHelper } }
  let(:subject) { dummy_class.new }

  describe "#create_client" do
    it "create" do
      client = subject.create_client
      expect(client).not_to be_nil
    end
  end
end
