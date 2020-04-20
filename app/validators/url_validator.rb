# frozen_string_literal: true

## Handles Validations for UrlDatum ##
class UrlValidator < ActiveModel::Validator
  def validate(url_datum)
    source_url_exists(url_datum)
  end

  ## Check for URL Actually Exists ##
  def source_url_exists(url_datum)
    return unless url_datum.source_url.present?

    url_datum.errors.add :source_url, 'does not exists' unless url_exist?(url_datum.source_url)
  end

  def url_exist?(url)
    url = URI.parse(url)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = url.scheme.eql?('https')
    path = url.path if url.path.present?
    res = req.request_head(path || '/')
    return url_exist?(res['location']) if res.is_a?(Net::HTTPRedirection)

    !%w[4 5].include?(res.code[0])
  rescue Errno::ENOENT, Errno::ECONNREFUSED, SocketError, URI::InvalidURIError
    false
  end
end
