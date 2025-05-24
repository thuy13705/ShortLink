require 'rails_helper'

RSpec.describe "Api::V1::Urls", type: :request do
   let(:original_url) { "https://example.com" }

  describe "POST /api/v1/encode" do
    it "returns 400 when url is missing" do
      post "/api/v1/encode", params: {}

      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("url is required")
    end

    it "returns 400 when url is invalid" do
      post "/api/v1/encode", params: { url: "not_a_valid_url" }

      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("invalid url format")
    end

    it "returns the same short URL for the same original URL" do
      post "/api/v1/encode", params: { url: original_url }
      first_short_url = JSON.parse(response.body)["short_url"]

      post "/api/v1/encode", params: { url: original_url }
      second_short_url = JSON.parse(response.body)["short_url"]

      expect(first_short_url).to eq(second_short_url)
    end

    it "encodes a URL and returns the short URL" do
      post "/api/v1/encode", params: { url: original_url }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["short_url"]).to start_with("http://")
      expect(json["short_url"]).to include("/")
    end

    it "generates different short URLs for different original URLs" do
      post "/api/v1/encode", params: { url: "https://example.com/1" }
      short_url1 = JSON.parse(response.body)["short_url"]

      post "/api/v1/encode", params: { url: "https://example.com/2" }
      short_url2 = JSON.parse(response.body)["short_url"]

      expect(short_url1).not_to eq(short_url2)
    end
  end

  describe "POST /api/v1/decode" do
    it "decodes a short URL and returns the original URL" do
      post "/api/v1/encode", params: { url: original_url }
      short_url = JSON.parse(response.body)["short_url"]

      post "/api/v1/decode", params: { url: short_url }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["original_url"]).to eq(original_url)
    end

    it "returns 404 when short URL is not found" do
      post "/api/v1/decode", params: { url: "http://localhost:3000/unknown123" }

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Not found")
    end

    it "returns 400 when short_url param is missing" do
      post "/api/v1/decode", params: {}

      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("short_url is required")
    end

    it "does not decode malformed short_url" do
      post "/api/v1/decode", params: { url: "this-is-not-a-url" }

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Not found")
    end
  end
end
