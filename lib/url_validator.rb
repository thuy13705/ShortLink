require 'uri'
require 'ipaddr'

module UrlValidator
  def self.valid_format?(url)
    uri = URI.parse(url)
    return %w[http https].include?(uri.scheme) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def self.safe_public_url?(url)
    uri = URI.parse(url)
    host = uri.host

    ip = IPAddr.new(host) rescue nil
    if ip
      return false if ip.private? || ip.loopback? || ip.link_local? || ip.multicast?
    else
      return false if host =~ /\Alocalhost\z/i
      # Add domain blacklist if need
    end

    true
  rescue URI::InvalidURIError
    false
  end
end
