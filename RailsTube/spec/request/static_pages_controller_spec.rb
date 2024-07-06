require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /home" do
    it "responds successfully with an HTTP 200 status code" do
      get home_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /short" do
    it "responds successfully with an HTTP 200 status code" do
      get short_path
      expect(response).to have_http_status(200)
    end
  end
  
  describe "GET /channels" do
    it "responds successfully with an HTTP 200 status code" do
      get channels_path
      expect(response).to have_http_status(200)
    end
  end
end
