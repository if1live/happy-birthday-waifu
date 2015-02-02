require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  include Devise::TestHelpers

  describe "GET show" do
    let(:user) { FactoryGirl.create(:user) }

    it "anonymous" do
      get :show
      expect(response).to have_http_status(403)
    end

    it "login" do
      sign_in user
      expect(response).to have_http_status(200)
    end
  end

end
