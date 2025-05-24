require 'uri'
require 'ipaddr'

module UrlValidator
  # Kiểm tra định dạng URL
  def self.valid_format?(url)
    uri = URI.parse(url)
    return %w[http https].include?(uri.scheme) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  # Kiểm tra URL có phải public và an toàn (không phải IP private, localhost,...)
  def self.safe_public_url?(url)
    uri = URI.parse(url)
    host = uri.host

    # Bỏ qua nếu host là IP private hoặc localhost
    ip = IPAddr.new(host) rescue nil
    if ip
      return false if ip.private? || ip.loopback? || ip.link_local? || ip.multicast?
    else
      # Nếu không phải IP, kiểm tra nếu hostname là localhost hoặc dạng cục bộ
      return false if host =~ /\Alocalhost\z/i
      # Thêm domain blacklist nếu cần
    end

    true
  rescue URI::InvalidURIError
    false
  end
end
