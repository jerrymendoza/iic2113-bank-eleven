require 'rails_helper'

RSpec.describe "Indices", type: :request do
  describe "GET /welcome" do
    it "returns http success" do
      get "/index/welcome"
      expect(response).to have_http_status(:success)
    end
  end
end
