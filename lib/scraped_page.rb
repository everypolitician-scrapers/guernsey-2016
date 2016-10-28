# frozen_string_literal: true
require 'nokogiri'
require 'uri'
require 'field_serializer'

require_rel 'scraped_page'

# Abstract class which scrapers can extend to implement their functionality.
class ScrapedPage
  include FieldSerializer

  def initialize(url:, strategy: ScrapedPage::LiveRequestStrategy)
    @url = url
    @strategy = strategy.new(url)
  end

  def noko
    @noko ||= Nokogiri::HTML(strategy.body)
  end

  private

  attr_reader :url, :strategy

  def absolute_url(rel)
    return if rel.to_s.empty?
    URI.join(url, URI.encode(URI.decode(rel)))
  end
end
