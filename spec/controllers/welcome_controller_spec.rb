require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller do

  describe "GET about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET dev_history" do
    it "returns http success" do
      get :dev_history
      expect(response).to have_http_status(:success)
    end
  end

end
