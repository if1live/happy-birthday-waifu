require 'rails_helper'


describe NotificationHelper do
  let(:dummy_class) { Class.new { include NotificationHelper } }
  let(:subject) { dummy_class.new }

  describe "#create_client" do
    it "create" do
      client = subject.create_client
      expect(client).not_to be_nil
    end
  end
end
