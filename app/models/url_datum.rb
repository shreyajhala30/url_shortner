# frozen_string_literal: true

## URLs Model ##
class UrlDatum < ApplicationRecord
  ## Validations ##
  validates :source_url, presence: true, uniqueness: true,
                         format: { with: URI::DEFAULT_PARSER.make_regexp,
                                   message: 'is invalid' }
  # validates :sanitized_url, presence: true, uniqueness: true
  validates_with UrlValidator, if: -> { source_url.present? }

  ## Callbacks ##
  before_save :sanitize_url_and_assign_token

  ## Instance Methods ##
  def sanitize_url
    return unless source_url.present?

    source_url.strip!
    sanitized_url = source_url.downcase.gsub(%r{(https?://)|(www\.)}, '')
    sanitized_url.slice!(-1) if sanitized_url[-1] == '/'
    self.sanitized_url = "http://#{sanitized_url}"
  end

  private

  def sanitize_url_and_assign_token
    sanitize_url
    chars = ['0'..'9', 'A'..'Z', 'a'..'z'].map(&:to_a).flatten
    loop do
      token = 6.times.map { chars.sample }.join
      self.token = token
      break unless UrlDatum.where(token: token).exists?
    end
  end
end
