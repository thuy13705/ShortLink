class ShortUrl < ApplicationRecord
  validates :original_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :short_code, presence: true, uniqueness: true

  before_validation :generate_short_code, on: :create

  private

  def generate_short_code
    return if short_code.present?

    loop do
      self.short_code = SecureRandom.alphanumeric(6)
      break unless ShortUrl.exists?(short_code: short_code)
    end
  end
end
