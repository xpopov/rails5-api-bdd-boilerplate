class Page < ApplicationRecord
  
  class HttpUrlValidator < ActiveModel::EachValidator
    def self.compliant?(value)
      uri = URI.parse(value)
      uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end

    def validate_each(record, attribute, value)
      unless value.present? && self.class.compliant?(value)
        record.errors.add(attribute, "is not a valid HTTP URL")
      end
    end
  end

  # validates :url, presence: true
  validates :url, http_url: true
  validates :title, presence: true
  validates :h1, presence: true
  validates :h2, presence: true
  validates :h3, presence: true
  validates :links, presence: true

  # Fake upsert
  def self.upsert(attributes)
    begin
      p = self.find_or_create_by(url: attributes[:url])
      p.update(attributes)
      p
    end
  end
end
