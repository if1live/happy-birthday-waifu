require 'rails_helper'

RSpec.describe CharactersController, :type => :controller do
  include Devise::TestHelpers

  describe "#assign_month_day" do
    it "success" do
      get :date, month: 2, day: 5
      expect(response).to have_http_status(:success)
    end

    it "invalid date" do
      get :date, month: 1, day: 0
      expect(response).to have_http_status(403)

      get :date, month: 1, day: 32
      expect(response).to have_http_status(403)

      get :date, month: 0, day: 1
      expect(response).to have_http_status(403)

      get :date, month: 13, day: 1
      expect(response).to have_http_status(403)
    end
  end

  describe "GET date" do
    let!(:character) { FactoryGirl.create(:character) }

    it "returns http success" do
      get :date, month: 2, day: 5
      expect(response).to have_http_status(:success)
      expect(assigns(:character_list)).to eq([character])
    end

    it "no data" do
      get :date, month: 2, day: 4
      expect(response).to have_http_status(:success)
      expect(assigns(:character_list)).to be_empty
    end
  end

  describe "GET index" do
    let!(:character) { FactoryGirl.create(:character) }

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:all_list)).to eq([character])
    end
  end

  describe "GET show" do
    let!(:character) { FactoryGirl.create(:character) }

    it "returns http success" do
      get :show, id: character.id
      expect(response).to have_http_status(:success)
      expect(assigns(:character)).to eq(character)
    end

    it "access not exist" do
      get :show, id: -1
      expect(response).to have_http_status(404)
    end
  end

  describe "GET root_index" do
    let!(:today_character) { FactoryGirl.create(:character) }
    let!(:tomorrow_character) { FactoryGirl.create(:tomorrow_character) }
    let!(:yesterday_character) { FactoryGirl.create(:yesterday_character) }

    it "returns http success" do
      get :root_index, month: 2, day: 5
      expect(response).to have_http_status(:success)
      expect(assigns(:today_list)).to eq([today_character])
      expect(assigns(:tomorrow_list)).to eq([tomorrow_character])
      expect(assigns(:approach_list)).to eq([yesterday_character])
    end
  end
end
