require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
 it "is valid with valid attributes" do
    url = ShortUrl.new(original_url: "https://example.com")
    expect(url).to be_valid
  end

  it "is not valid without original_url" do
    url = ShortUrl.new(original_url: nil)
    expect(url).not_to be_valid
  end
end
